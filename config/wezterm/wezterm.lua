local wezterm = require "wezterm"

return {
  font = wezterm.font "FiraCode Nerd Font",
  font_size = 15.0,
  color_scheme = "Snazzy",

  scrollback_lines = 10000,

  window_padding = {
    left = 2,
    right = 2,
    top = 2,
    bottom = 2,
  },
}
