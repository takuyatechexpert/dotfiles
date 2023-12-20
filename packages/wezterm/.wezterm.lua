local wezterm = require 'wezterm'
local act = wezterm.action
local config = {}

config.keys = {
  { key = 'p', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = 'n', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(1) },
}

return config
