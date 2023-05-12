local wezterm = require "wezterm"
local project = require "project"
local act = wezterm.action

wezterm.on('gui-startup', function()
  project.startup("WZ_PROJECT", "projects", wezterm)
end)

local copy_mode = nil
if wezterm.gui then
  copy_mode = wezterm.gui.default_key_tables().copy_mode
  -- Same shorcuts as .inputrc
  local custom_copy_mode = {
    { key = 'RightArrow', mods = 'CTRL', action = act.CopyMode 'MoveForwardWord' },
    { key = 'LeftArrow',  mods = 'CTRL', action = act.CopyMode 'MoveBackwardWord' }
  }
  for _, x in ipairs(custom_copy_mode) do
    table.insert(copy_mode, x)
  end
end

return {
  -- Avoid spawning login shell that causes starship to always shop the `jobs` module
  default_prog = { os.getenv("SHELL") },
  font = wezterm.font "FiraCode Nerd Font",
  font_size = 15.0,
  color_scheme = "Snazzy",
  force_reverse_video_cursor = true,
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
  key_tables = {
    copy_mode = copy_mode
  }
}
