# telescope-cheat-md.nvim

### 🌟 Features

An attempt to recreate cheat.sh with lua, neovim, `sqlite.lua` and `telescope.nvim`.

Using for markdown-type source only:
+ [learnxinyminutes-docs](https://github.com/adambard/learnxinyminutes-docs) 
+ [rstacruz-cheatsheets](https://github.com/rstacruz/cheatsheets)

![](./preview.gif)

### ⚡️Requirements

- Neovim 0.10+
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [sqlite.lua](https://github.com/kkharji/sqlite.lua)
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)

### 📦 Installation

Install via your favorite package manager:

#### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
require("lazy").setup(
{
    "yorik1984/telescope-cheat-md.nvim",
    dependencies = {
        "kkharji/sqlite.lua",
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
    },
    keys = {
        { "<leader>Tcf", "<CMD>Telescope cheat_md fd<CR>",      desc = "Telescope cheat_md fd" },
        { "<leader>Tcr", "<CMD>Telescope cheat_md recache<CR>", desc = "Telescope cheat_md recache" },
    },
    config = function()
        require("telescope").load_extension("cheat_md")
    end,
}
)
```

### 🚀 Usage

#### 💻 Commands

```vim
:Telescope cheat_md fd
:Telescope cheat_md recache " cheat will be auto cached with new updates on sources
```
#### ⌨️ Keymaps

Use [Telescope Default Mappings](https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#default-mappings)

| Mappings       | Action                             |
| -------------- | ---------------------------------- |
| `<CR>`         | Confirm selection                  |
| `<C-x>`        | Go to file selection as a split    |
| `<C-v>`        | Go to file selection as a vsplit   |
| `<C-t>`        | Go to a file in a new tab          |
