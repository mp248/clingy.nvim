# 😍 clingy.nvim

Clingy line numbers indent with your text.
   
<img width="1006" height="822" alt="Screenshot 2026-06-15 at 7 26 36 PM" src="https://github.com/user-attachments/assets/82027f24-aa6c-4a7e-b99d-dc6882bd4a52" />

## 📦 Installation

Install the plugin using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "mp248/clingy.nvim",
    opts = {} -- For default options. Refer to the configuration section for custom setup.
}
```

## ⚙️ Configuration

Clingy number behavior can be customized. The default values are:

```lua
{
    enabled = false, -- Toggle activation on Neovim launch.
    relative_nr = true,  -- Enable relative line numbers.
    padding = 2, -- Number of spaces between clingy numbers and your text.
    line_nr_color = "LineNr", -- Color of standard clingy numbers (supports highlight groups or raw hex codes).
    cursor_line_nr_color = "CursorLineNr", -- Color of the clingy number at your cursor (supports highlight groups or raw hex codes).
}
```

## 🚀 Usage

Toggle Clingy numbers using the following command:

```
:Clingy
```
