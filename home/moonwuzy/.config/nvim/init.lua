-- Simple, Nano-inspired Neovim configuration

-- Basic editor behavior
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.wrap = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

-- Start in insert mode so typing feels like Nano
vim.api.nvim_create_autocmd("VimEnter", {
callback = function()
vim.cmd("startinsert")
end,
})

-- Nano-style shortcuts
vim.keymap.set("n", "<C-s>", "<cmd>write<CR>", { desc = "Save file" })
vim.keymap.set("i", "<C-s>", "<Esc><cmd>write<CR>a", { desc = "Save file" })
vim.keymap.set("n", "<C-x>", "<cmd>confirm qall<CR>", { desc = "Exit" })
vim.keymap.set("i", "<C-x>", "<Esc><cmd>confirm qall<CR>", { desc = "Exit" })
vim.keymap.set("n", "<C-o>", "<cmd>write<CR>", { desc = "Save file" })
vim.keymap.set("i", "<C-o>", "<Esc><cmd>write<CR>a", { desc = "Save file" })
vim.keymap.set("n", "<C-w>", "/", { desc = "Find text" })
vim.keymap.set("i", "<C-w>", "<Esc>/", { desc = "Find text" })
vim.keymap.set("n", "<C-k>", "dd", { desc = "Cut line" })
vim.keymap.set("i", "<C-k>", "<Esc>ddi", { desc = "Cut line" })
vim.keymap.set("n", "<C-u>", "P", { desc = "Paste line" })
vim.keymap.set("i", "<C-u>", "<Esc>Pi", { desc = "Paste line" })

-- Keep the interface simple
vim.opt.showmode = true
vim.opt.laststatus = 2
vim.opt.cmdheight = 1

vim.opt.background = "dark"
vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
vim.cmd("highlight NormalFloat guibg=NONE ctermbg=NONE")
vim.cmd("highlight SignColumn guibg=NONE ctermbg=NONE")
vim.cmd("highlight EndOfBuffer guibg=NONE ctermbg=NONE")

vim.opt.guicursor = ""
