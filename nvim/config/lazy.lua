-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({

  spec = {
    { "rhysd/clever-f.vim" },
    { "unblevable/quick-scope" },
    { "wellle/targets.vim" },
    {
      "monaqa/dial.nvim",
      keys = {
        { "<C-a>", function() require("dial.map").manipulate("increment", "normal") end, desc = "Increment" },
        { "<C-x>", function() require("dial.map").manipulate("decrement", "normal") end, desc = "Decrement" },
        { "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end, desc = "Increment (sequential)" },
        { "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end, desc = "Decrement (sequential)" },
        { "<C-a>", function() require("dial.map").manipulate("increment", "visual") end, mode = "x", desc = "Increment" },
        { "<C-x>", function() require("dial.map").manipulate("decrement", "visual") end, mode = "x", desc = "Decrement" },
        { "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end, mode = "x", desc = "Increment (sequential)" },
        { "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end, mode = "x", desc = "Decrement (sequential)" },
      },
    },
    {
      "rapan931/lasterisk.nvim",
      keys = {
        { "*", function() require("lasterisk").search() end, desc = "Search word under cursor" },
        { "g*", function() require("lasterisk").search({ is_whole = false }) end, desc = "Search partial word" },
        { "*", function() require("lasterisk").search({ is_whole = false }) end, mode = "x", desc = "Search selection" },
      },
    },
    { "kevinhwang91/nvim-hlslens", opts = {} },
    {
      "gbprod/substitute.nvim",
      opts = {},
      keys = {
        { "s", function() require("substitute").operator() end, desc = "Substitute operator" },
        { "ss", function() require("substitute").line() end, desc = "Substitute line" },
        { "S", function() require("substitute").eol() end, desc = "Substitute to end of line" },
        { "s", function() require("substitute").visual() end, mode = "x", desc = "Substitute selection" },
      },
    },
    { "haya14busa/vim-edgemotion" },
    { "haya14busa/vim-metarepeat" },
    {
      -- switches back to the ASCII input method when leaving insert mode.
      -- The plugin picks the switcher per OS (macism on macOS, im-select.exe
      -- on Windows/WSL, fcitx/ibus on Linux), so load it only where one exists.
      "keaising/im-select.nvim",
      cond = function()
        for _, cmd in ipairs({ "macism", "im-select.exe", "fcitx5-remote", "fcitx-remote", "ibus" }) do
          if vim.fn.executable(cmd) == 1 then
            return true
          end
        end
        return false
      end,
      opts = {},
    },
    { "kylechui/nvim-surround", event = "VeryLazy", opts = {} },
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "catppuccin-latte" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
