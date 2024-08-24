local wezterm = require "wezterm"
local project = require "project"
local helpers = require "helpers"
local act = wezterm.action

local WZ_PROJECT = "WZ_PROJECT"

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

wezterm.on("gui-startup", function()
  project.startup(WZ_PROJECT, "projects", wezterm)
end)

wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
  return project.format_window_title(WZ_PROJECT, tab, tabs)
end)

local copy_mode = nil
if wezterm.gui then
  copy_mode = helpers.tables.concat(
    wezterm.gui.default_key_tables().copy_mode, {
      { key = "RightArrow", mods = "CTRL", action = act.CopyMode "MoveForwardWord" },
      { key = "LeftArrow",  mods = "CTRL", action = act.CopyMode "MoveBackwardWord" }
    })
end

-- Avoid spawning login shell that causes starship to always shop the `jobs` module
config.default_prog = { os.getenv("SHELL") }

config.font = wezterm.font "FiraCode Nerd Font"
config.font_size = 15.0

-- config.color_scheme = "Snazzy"
config.color_scheme = "GruvboxDarkHard"
config.force_reverse_video_cursor = true

config.scrollback_lines = 30000
config.enable_scroll_bar = true
config.min_scroll_bar_height = "1cell"
config.window_padding = {
  left = 2,
  right = 4,
  top = 2,
  bottom = 2,
}

config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true

config.inactive_pane_hsb = {
  brightness = 0.5,
}

config.colors = {
  scrollbar_thumb = 'rgba(255,255,255,0.7)',
}

config.keys = {
  { key = "LeftArrow",  mods = "SHIFT|ALT", action = act.MoveTabRelative(-1) },
  { key = "RightArrow", mods = "SHIFT|ALT", action = act.MoveTabRelative(1) },
}
config.key_tables = {
  copy_mode = copy_mode
}

return config
