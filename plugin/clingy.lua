local clingy_group = vim.api.nvim_create_augroup("ClingyGroup", { clear = true })

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "TextChanged", "TextChangedI", "WinScrolled" }, {
  group = clingy_group,
  callback = require("clingy").clingy,
})

vim.api.nvim_create_user_command("Clingy", function()
  require("clingy").toggle()
end, {})
