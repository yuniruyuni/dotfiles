-- The leader keys have to be set before any plugin defines its mappings.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Basic settings
vim.opt.number = true
vim.opt.signcolumn = "yes" -- keep the text from shifting when diagnostics appear
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.background = "light"
vim.opt.winborder = "rounded" -- border of hover, diagnostics and other floats
vim.opt.showtabline = 2 -- always show the tab line, also with a single tab

-- ng (the Neovim GUI) opens its window at the size of the grid, 80x24 unless
-- told otherwise. It sets g:ng before this file is read.
if vim.g.ng then
  vim.opt.columns = 140
  vim.opt.lines = 45
end

-- Completion: show the built-in menu while typing, without a plugin.
-- "o" adds 'omnifunc', which is where language servers plug in.
vim.opt.autocomplete = true
vim.opt.complete = { ".", "w", "b", "u", "o" }
vim.opt.completeopt = { "menuone", "noselect", "popup", "fuzzy" }

-- Key mappings
local map = vim.keymap.set

map("n", "<Space>", "<Nop>")
map("n", "qq", "<Cmd>q!<CR>", { desc = "Quit without saving" })
map("n", "<C-h>", "<C-w>h", { desc = "Go to the left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to the window below" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to the window above" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to the right window" })
-- Tabs. These take tt, tl and th away from the t motion ("till the next
-- t/l/h"); t followed by any other character still works at once.
map("n", "tt", "<Cmd>tabnew<CR>", { desc = "New tab" })
map("n", "tl", "<Cmd>tabnext<CR>", { desc = "Go to the tab on the right" })
map("n", "th", "<Cmd>tabprevious<CR>", { desc = "Go to the tab on the left" })
