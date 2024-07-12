-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.termguicolors = true

-- Key mappings
vim.g.mapleader = " "
vim.api.nvim_set_keymap('n', '<Space>', '<Nop>', { noremap = true, silent = true })

if vim.g.vscode then
  -- VSCode extension
  vim.api.nvim_set_keymap('x', 'gc', '<Plug>VSCodeCommentary', {})
  vim.api.nvim_set_keymap('n', 'gc', '<Plug>VSCodeCommentary', {})
  vim.api.nvim_set_keymap('o', 'gc', '<Plug>VSCodeCommentary', {})
  vim.api.nvim_set_keymap('n', 'gcc', '<Plug>VSCodeCommentaryLine', {})
  vim.api.nvim_set_keymap('n', 'qq', ':tabclose<CR>', { noremap = true, silent = true })
else
  -- Non VSCode Neovim specific settings
  vim.api.nvim_set_keymap('n', 'qq', ':q!<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })
end
