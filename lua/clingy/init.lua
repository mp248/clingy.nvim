local M = {}

local default_config = {
  enabled = false,
  relative_nr = true,
  padding = 3,
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

  if not M.config.enabled then
    return
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_line = cursor[1]
  local win_info = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local top_line = win_info.topline
  local bottom_line = win_info.botline

  for i = top_line, bottom_line do
    local line_content = vim.api.nvim_buf_get_lines(
      buffer,
      i - 1,
      i,
      false
    )

    local first_non_space = line_content[1] and line_content[1]:find("%S")

    if first_non_space then
      local column = first_non_space - 1

      -- formatting and color
      local clingy_number = (i == cursor_line or not M.config.relative_nr) and string.format("%3d", i) or string.format("%3d", math.abs(i - cursor_line))
      clingy_number = clingy_number .. string.rep(" ", M.config.padding)

      local color_input = (cursor_line == i) and M.config.cursor_line_nr_color or M.config.line_nr_color
      local resolved_color = resolve_color(color_input)

      -- create extmark
      vim.api.nvim_buf_set_extmark(
        buffer,
        namespace_id,
        i - 1,
        column,
        {
          virt_text = { { clingy_number, resolved_color } },
          virt_text_pos = "inline",
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
