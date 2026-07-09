# clingy.nvim

Clingy line numbers indent with your text.

<img width="620" height="542" alt="clingy_demo" src="https://github.com/user-attachments/assets/dc188065-83a0-439f-a9fe-a6cc296aa6a6" />

## Installation

Install the plugin using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "mp248/clingy.nvim",
    opts = {}, -- For default options. Refer to the configuration section for custom setup.
}
```

## Configuration

Clingy number behavior can be customized. The default values are:

```lua
{
    enabled = false, -- Toggle activation on Neovim launch.
    relative_nr = true,  -- Enable relative line numbers.
    skip_empty_lines = false, -- Prevent rendering clingy numbers for empty lines.
    threshold = 0, -- The maximum distance between a clingy number and the first non-whitespace character of its line.
    line_nr_color = "LineNr", -- Color of standard clingy numbers (supports highlight groups or raw hex codes).
    cursor_line_nr_color = "CursorLineNr", -- Color of the clingy number at your cursor (supports highlight groups or raw hex codes).
}
```

## Usage

Toggle Clingy numbers using the following command:

```
:Clingy
```
