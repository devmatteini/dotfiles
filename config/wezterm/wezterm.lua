local wezterm = require "wezterm"

return {
  font = wezterm.font "FiraCode Nerd Font",
  font_size = 15.0,
  color_scheme = "Gruvbox dark, hard (base16)",

  scrollback_lines = 10000,

  window_padding = {
    left = 2,
    right = 2,
    top = 2,
    bottom = 2,
  },

  inactive_pane_hsb = {
    brightness = 0.5,
  },
}
