local wezterm = require "wezterm"
local project = require "project"
local act = wezterm.action

wezterm.on('gui-startup', function()
  project.startup("WZ_PROJECT", "projects", wezterm)
end)

return {
  -- Avoid spawning login shell that causes starship to always shop the `jobs` module
  default_prog = { os.getenv("SHELL") },
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
  inactive_pane_hsb = {
    brightness = 0.5,
  },
  keys = {
    { key = 'LeftArrow',  mods = 'SHIFT|ALT', action = act.MoveTabRelative(-1) },
    { key = 'RightArrow', mods = 'SHIFT|ALT', action = act.MoveTabRelative(1) },
  },
}
