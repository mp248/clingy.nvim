local M = {}

M.enabled = false

local namespace_id = vim.api.nvim_create_namespace("clingy")

function M.clingy()
  local buffer = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(buffer, namespace_id, 0, -1)

  if not M.enabled then
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

      local clingy_number = string.format("%3d ", math.abs(i - cursor_line))
      clingy_number = clingy_number .. " "

      vim.api.nvim_buf_set_extmark(
        buffer,
        namespace_id,
        i - 1,
        column,
        {
          virt_text = { { clingy_number, "ErrorMsg" } },
          virt_text_pos = "inline",
        }
      )

    end
  end
end

function M.toggle()
  M.enabled = not M.enabled
  M.clingy()
end

return M
