local wezterm = require 'wezterm'

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.window_close_confirmation = 'NeverPrompt'

config.color_scheme = 'GitHub Dark'

config.font = wezterm.font 'Fira Code'
config.font_size = 16.0
config.line_height = 1.1

config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.window_background_opacity = 0.8

config.use_fancy_tab_bar = false
config.enable_tab_bar = false

config.default_prog = { 'nu' }

config.enable_csi_u_key_encoding = true;

return config
