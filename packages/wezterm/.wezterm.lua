local wezterm = require 'wezterm'
local act = wezterm.action
local config = {}

config.keys = {
  -- move tab
  { key = 'p', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = 'n', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(1) },

  -- ScrollByPage
  { key = 'y', mods = 'CTRL|SHIFT', action = act.ScrollByLine(-1) },
  { key = 'e', mods = 'CTRL|SHIFT', action = act.ScrollByLine(1) },
}

return config
