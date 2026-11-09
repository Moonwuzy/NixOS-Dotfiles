
-- Neovim: Default Vim keybinds + Nano-style shortcut bar

-- Editor behavior
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.wrap = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

-- Interface
vim.opt.showmode = true
vim.opt.laststatus = 2
vim.opt.cmdheight = 1
vim.opt.background = "dark"

-- Transparent background
vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
vim.cmd("highlight NormalFloat guibg=NONE ctermbg=NONE")
vim.cmd("highlight SignColumn guibg=NONE ctermbg=NONE")
vim.cmd("highlight EndOfBuffer guibg=NONE ctermbg=NONE")

-- Cursor
vim.opt.guicursor = ""

-- Bottom shortcut bar
vim.opt.statusline =
  "  i Insert  |  Esc Normal  |  :w Save  |  :q Quit  |  :wq Save & Quit  |  / Search  |  n/N Next/Prev  |  u Undo  |  Ctrl-r Redo"

