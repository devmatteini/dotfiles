local wezterm = require "wezterm"
local act = wezterm.action

return {
  -- Avoid spawning login shell that causes starship to always shop the `jobs` module
  default_prog = { os.getenv("SHELL") },
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
  hyperlink_rules = {
    -- Linkify things that look like URLs and the host has a TLD name.
    -- Compiled-in default. Used if you don't specify any hyperlink_rules.
    {
      regex = '\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b',
      format = '$0',
    },
    -- Linkify things that look like URLs with numeric addresses as hosts.
    -- E.g. http://127.0.0.1:8000 for a local development server,
    -- or http://192.168.1.1 for the web interface of many routers.
    {
      regex = "\\b\\w+://(?:[\\w.-]+)(:\\d+)?\\S*\\b",
      format = "$0",
    },
    -- file:// URI
    -- Compiled-in default. Used if you don't specify any hyperlink_rules.
    {
      regex = [[\bfile://\S*\b]],
      format = '$0',
    },
  },
  keys = {
    { key = 'LeftArrow',  mods = 'SHIFT|ALT', action = act.MoveTabRelative(-1) },
    { key = 'RightArrow', mods = 'SHIFT|ALT', action = act.MoveTabRelative(1) },
  },
}
