local wezterm = require 'wezterm'
local config = wezterm.config_builder()
config.automatically_reload_config = true

local triple = wezterm.target_triple
if triple:find("windows") then
    -- Use MSYS2 zsh as default shell on Windows
    -- Detect path: MSYS2_ROOT env var → C:/tools/msys64 → C:/msys64
    local msys2_root = os.getenv("MSYS2_ROOT") or "C:/tools/msys64"
    msys2_root = msys2_root:gsub("\\", "/")
    config.default_prog = { msys2_root .. '/usr/bin/zsh.exe', '-l' }
elseif triple:find("darwin") or triple:find("linux") then
    config.default_prog = { 'zsh' }
end

config.window_close_confirmation = 'NeverPrompt'

config.initial_cols = 130
config.initial_rows = 45

config.window_background_opacity = 0.93

config.font = wezterm.font 'Cica'
config.color_scheme = 'Catppuccin Latte'
config.default_cursor_style = 'SteadyBar'
config.cursor_thickness = "1pt"
config.status_update_interval = 1000
config.scrollback_lines = 3500
config.animation_fps = 120

config.show_new_tab_button_in_tab_bar = true

config.window_frame = {
  font = wezterm.font { family = 'Cica' },
  font_size = 12.0,
  active_titlebar_bg = '#ccd0da',
  inactive_titlebar_bg = '#ccd0da',
}

config.colors = {
  tab_bar = {
    background = '#4c4f69',
    inactive_tab_edge = '#eff1f5',

    active_tab = {
      bg_color = '#eff1f5',
      fg_color = '#4c4f69',
      intensity = 'Normal',
      underline = 'None',
      italic = false,
      strikethrough = false,
    },

    inactive_tab = {
      bg_color = '#ccd0da',
      fg_color = '#bcc0cc',
    },

    inactive_tab_hover = {
      bg_color = '#e6e9ef',
      fg_color = '#4c4f69',
    },

    new_tab = {
      bg_color = '#ccd0da',
      fg_color = '#4c4f69',
    },

    new_tab_hover = {
      bg_color = '#ccd0da',
      fg_color = '#4c4f69',
    },
  },
}

return config
