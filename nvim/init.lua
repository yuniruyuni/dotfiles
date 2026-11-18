-- This file is loaded with dofile() from ~/.config/nvim/init.lua (see
-- setup.sh), so the repository directory is not on 'runtimepath'. Make the
-- modules next to this file reachable with require().
local dir = debug.getinfo(1, "S").source:match("@?(.*[/\\])")
package.path = package.path .. ";" .. dir .. "?.lua"

require("config.basic") -- options and keymaps; sets the leader key first
require("config.lazy") -- plugins
require("config.lsp") -- language servers, completion, diagnostics
