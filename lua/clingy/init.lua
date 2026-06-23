local M = {}

local default_config = {
  enabled = false,
  relative_nr = true,
  threshold = 0,
  line_nr_color = "LineNr",
  cursor_line_nr_color = "CursorLineNr",
}

M.config = {}

function M.setup(user_options)
  M.config = vim.tbl_deep_extend("force", default_config, user_options or {})
end

local function resolve_color(color_input)
  if color_input:sub(1, 1) == "#" then
    local new_color = "ClingyHex" .. color_input:gsub("#", "")
    vim.api.nvim_set_hl(0, new_color, { fg = color_input })
    return new_color
  end

  return color_input
end

local namespace_id = vim.api.nvim_create_namespace("clingy")

function M.clingy()
  local buffer = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(buffer, namespace_id, 0, -1)

  -- check if clingy numbers are enabled
  if not M.config.enabled then
    return
  end

  -- get line number at cursor
  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_line = cursor[1]

  -- get range of line numbers currently in view
  local win_info = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local top_line = win_info.topline
  local bottom_line = win_info.botline

  -- the leftmost column currently in view
  local leftmost_column = vim.fn.winsaveview().leftcol

  -- create format specifier
  local bottom_line_nr_width = #tostring(bottom_line)
  local max_line_nr_width = bottom_line_nr_width > 3 and bottom_line_nr_width or 3
  local format_specifier = "%" .. max_line_nr_width .. "d"

  -- get all lines in buffer
  local lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)

  for i = top_line, bottom_line do
    local line = lines[i]
    local first_non_space = line and line:find("%S")

    if first_non_space then
      local clingy_column = first_non_space - 1

      -- formatting
      local clingy_number = (i == cursor_line or not M.config.relative_nr) and string.format(format_specifier, i) or string.format(format_specifier, math.abs(i - cursor_line))
      clingy_number = clingy_number .. " "

      -- color
      local color_input = cursor_line == i and M.config.cursor_line_nr_color or M.config.line_nr_color
      local resolved_color = resolve_color(color_input)

      -- indent line with a blank inline extmark
      vim.api.nvim_buf_set_extmark(
        buffer,
        namespace_id,
        i - 1,
        clingy_column,
        {
          virt_text = { { string.rep(" ", max_line_nr_width + 1) } },
          virt_text_pos = "inline",
        }
      )

      -- draw clingy number with overlay extmark
      vim.api.nvim_buf_set_extmark(
        buffer,
        namespace_id,
        i - 1,
        0,
        {
          virt_text = { { clingy_number, resolved_color } },
          virt_text_win_col = math.max(clingy_column - leftmost_column - M.config.threshold, 0),
        }
      )
    end
  end
end

function M.toggle()
  M.config.enabled = not M.config.enabled
  M.clingy()
end

M.setup()

return M
