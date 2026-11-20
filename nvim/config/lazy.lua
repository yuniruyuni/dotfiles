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

-- Setup lazy.nvim
require("lazy").setup({

  spec = {
    -- ---------------------------------------------------------- appearance
    {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000, -- load before everything else that draws
      config = function()
        vim.cmd.colorscheme("catppuccin-latte")
      end,
    },

    -- ------------------------------------------------------------- motions
    { "rhysd/clever-f.vim" },
    { "unblevable/quick-scope" },
    {
      -- j/k that stop at the edge of a block of code.
      "haya14busa/vim-edgemotion",
      keys = {
        { "<Leader>j", "<Plug>(edgemotion-j)", mode = { "n", "x", "o" }, desc = "Down to block edge" },
        { "<Leader>k", "<Plug>(edgemotion-k)", mode = { "n", "x", "o" }, desc = "Up to block edge" },
      },
    },

    -- ------------------------------------------------------------- editing
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
      "gbprod/substitute.nvim",
      opts = {},
      keys = {
        { "s", function() require("substitute").operator() end, desc = "Substitute operator" },
        { "ss", function() require("substitute").line() end, desc = "Substitute line" },
        { "S", function() require("substitute").eol() end, desc = "Substitute to end of line" },
        { "s", function() require("substitute").visual() end, mode = "x", desc = "Substitute selection" },
      },
    },
    { "kylechui/nvim-surround", event = "VeryLazy", opts = {} },
    { "haya14busa/vim-metarepeat" }, -- g. repeats the last change over a motion

    -- -------------------------------------------------------------- search
    {
      "rapan931/lasterisk.nvim",
      keys = {
        { "*", function() require("lasterisk").search() end, desc = "Search word under cursor" },
        { "g*", function() require("lasterisk").search({ is_whole = false }) end, desc = "Search partial word" },
        { "*", function() require("lasterisk").search({ is_whole = false }) end, mode = "x", desc = "Search selection" },
      },
    },
    { "kevinhwang91/nvim-hlslens", opts = {} },

    -- -------------------------------------------------------- text objects
    {
      "nvim-mini/mini.nvim",
      version = false,
      config = function()
        -- Text objects (replaces targets.vim). The "next"/"last" variants
        -- move off the default an/in/al/il: in visual mode Neovim itself
        -- uses an/in to grow and shrink the selection by syntax node.
        require("mini.ai").setup({
          mappings = {
            around_next = "aN",
            inside_next = "iN",
            around_last = "aL",
            inside_last = "iL",
          },
        })
      end,
      lazy = false,
    },

    -- -------------------------------------------------------------- picker
    {
      -- Fuzzy finder on top of the `fzf` command (also needs `rg` and `fd`).
      "ibhagwan/fzf-lua",
      cmd = "FzfLua",
      opts = {
        winopts = { fullscreen = true },
        files = {
          -- Only files that can be edited as text: instead of listing names
          -- (`rg --files`), let rg look into each file and print those with
          -- a line in them. rg skips binary files (anything with a NUL
          -- byte), as it does when searching. That leaves out empty files,
          -- which fd adds. rg must not find a pipe on stdin, or it searches
          -- that instead of the directory. (The rest is shell syntax: cmd.exe
          -- on Windows, sh elsewhere.)
          cmd = 'rg --files-with-matches --color=never --hidden --glob "!.git" ""'
            .. (vim.fn.has("win32") == 1 and " <NUL & " or " </dev/null ; ")
            .. "fd --color=never --hidden --exclude .git --type file --type empty",
        },
      },
      init = function()
        -- Route vim.ui.select (code actions and the like) through fzf, and
        -- load the plugin only when something first asks for a selection.
        vim.ui.select = function(...)
          require("fzf-lua").register_ui_select()
          return vim.ui.select(...)
        end
      end,
      keys = {
        { "<Leader>f", "<Cmd>FzfLua files<CR>", desc = "Find files" },
        { "<Leader>/", "<Cmd>FzfLua live_grep<CR>", desc = "Search in files" },
        { "<Leader>b", "<Cmd>FzfLua buffers<CR>", desc = "Find buffers" },
        { "<Leader>h", "<Cmd>FzfLua helptags<CR>", desc = "Find help" },
        { "<Leader>d", "<Cmd>FzfLua diagnostics_workspace<CR>", desc = "Find diagnostics" },
        { "<Leader>r", "<Cmd>FzfLua resume<CR>", desc = "Reopen the last picker" },
        {
          -- Pick a repository that `ghq` knows and work on it in a tab of
          -- its own: the tab's working directory (`:tcd`) is the
          -- repository, so <Leader>f and <Leader>/ look there.
          "<Leader>p",
          function()
            local roots = vim.fn.systemlist({ "ghq", "root", "--all" })
            local paths = vim.fn.systemlist({ "ghq", "list", "--full-path" })
            if vim.v.shell_error ~= 0 or #paths == 0 then
              vim.notify("ghq lists no repositories", vim.log.levels.WARN)
              return
            end
            -- Show the names without the root in front (github.com/a/b).
            local norm = function(path)
              return (vim.trim(path):gsub("\\", "/"):gsub("/$", ""))
            end
            local dirs, names = {}, {}
            for _, path in ipairs(paths) do
              local dir, name = norm(path), nil
              for _, root in ipairs(roots) do
                root = norm(root) .. "/"
                if dir:sub(1, #root):lower() == root:lower() then
                  name = dir:sub(#root + 1)
                end
              end
              name = dirs[name or dir] and dir or name or dir
              dirs[name] = dir
              names[#names + 1] = name
            end
            table.sort(names)
            require("fzf-lua").fzf_exec(names, {
              prompt = "Repository> ",
              actions = {
                ["default"] = function(selected)
                  local dir = selected[1] and dirs[selected[1]]
                  if not dir then
                    return
                  end
                  -- A tab with nothing in it yet is used as it is.
                  local blank = #vim.api.nvim_tabpage_list_wins(0) == 1
                    and vim.api.nvim_buf_get_name(0) == ""
                    and not vim.bo.modified
                    and vim.bo.buftype == ""
                  if not blank then
                    vim.cmd.tabnew()
                  end
                  vim.cmd.tcd(vim.fn.fnameescape(dir))
                end,
              },
            })
          end,
          desc = "Open a repository in a new tab",
        },
      },
    },

    -- ----------------------------------------------------------- file tree
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons", -- file type icons; needs a Nerd Font
      },
      cmd = "Neotree",
      keys = {
        -- the tree of the working directory, with the cursor on the file
        -- being edited
        { "<Leader>e", "<Cmd>Neotree toggle reveal<CR>", desc = "File tree" },
      },
      init = function()
        -- `nvim some/dir` should show the tree as well. The plugin is loaded
        -- on demand, so load it right away in that one case.
        local arg = vim.fn.argv(0)
        if vim.fn.argc() == 1 and type(arg) == "string" and vim.fn.isdirectory(arg) == 1 then
          require("neo-tree")
        end
      end,
      opts = {
        window = {
          position = "float", -- a dialog like the picker, not a sidebar
          popup = { size = { width = "90%", height = "90%" } },
        },
        filesystem = {
          hijack_netrw_behavior = "open_current",
          use_libuv_file_watcher = true, -- pick up changes made outside Neovim
          filtered_items = {
            -- dotfiles matter in most repositories (and are the whole point
            -- of this one); only keep the noise out.
            hide_dotfiles = false,
            hide_gitignored = true,
            hide_by_name = { ".git" },
          },
        },
      },
    },

    -- ----------------------------------------------------- syntax and LSP
    {
      -- Installs tree-sitter parsers. Building one needs the `tree-sitter`
      -- CLI and a C compiler; without the CLI only the parsers shipped with
      -- Neovim (lua, markdown, vim, ...) are highlighted this way.
      "nvim-treesitter/nvim-treesitter",
      branch = "main",
      lazy = false, -- the plugin does not support lazy loading
      build = ":TSUpdate",
      config = function()
        local ts = require("nvim-treesitter")
        local can_install = vim.fn.executable("tree-sitter") == 1
        local available = can_install and ts.get_available() or {}

        vim.api.nvim_create_autocmd("FileType", {
          group = vim.api.nvim_create_augroup("dotfiles_treesitter", { clear = true }),
          callback = function(ev)
            local lang = vim.treesitter.language.get_lang(ev.match)
            if not lang then
              return
            end
            if vim.treesitter.language.add(lang) then
              vim.treesitter.start(ev.buf, lang)
            elseif vim.list_contains(available, lang) then
              -- first time this language is opened: fetch its parser, then
              -- highlight the buffer that asked for it.
              ts.install(lang):await(function()
                if vim.api.nvim_buf_is_valid(ev.buf) and vim.treesitter.language.add(lang) then
                  vim.treesitter.start(ev.buf, lang)
                end
              end)
            end
          end,
        })
      end,
    },
    { "neovim/nvim-lspconfig" }, -- server definitions; enabled in config/lsp.lua

    -- ---------------------------------------------------------------- misc
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
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "catppuccin-latte" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
  -- keep the lockfile in this repository instead of stdpath("config"), so
  -- every system that loads this config (WSL and Windows share this
  -- directory) pins the same plugin versions.
  lockfile = debug.getinfo(1, "S").source:match("@?(.*)[/\\]config[/\\]") .. "/lazy-lock.json",
})
