local wezterm = require 'wezterm'
local act = wezterm.action
local config = {}

local function cs(key, action)
  return { key = key, mods = 'CTRL|SHIFT', action = action }
end

config.keys = {
  -- move tab
  cs('p', act.ActivateTabRelative(-1)),
  cs('n', act.ActivateTabRelative(1)),

  -- ScrollByPage
  cs('y', act.ScrollByLine(-1)),
  cs('e', act.ScrollByLine(1)),

  -- split pane
  cs('|', act.SplitHorizontal { domain = 'CurrentPaneDomain' }),
  cs('s', act.SplitVertical { domain = 'CurrentPaneDomain' }),

  -- move pane
  cs('h', act.ActivatePaneDirection 'Left'),
  cs('j', act.ActivatePaneDirection 'Down'),
  cs('k', act.ActivatePaneDirection 'Up'),
  cs('l', act.ActivatePaneDirection 'Right'),

  -- close pane
  cs('x', act.CloseCurrentPane { confirm = true }),
}

-- tab bar
config.window_decorations = 'RESIZE'
config.show_new_tab_button_in_tab_bar = false
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#5c6d74"
  local foreground = "#FFFFFF"

  if tab.is_active then
    background = "#2dad7c"
    foreground = "#FFFFFF"
  end

  local cwd = tab.active_pane.current_working_dir
  local dir_name = cwd and cwd.file_path:match("([^/]+)/?$") or tab.active_pane.title
  local title = "   " .. wezterm.truncate_right(dir_name, max_width) .. "   "

  return {
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
  }
end)

config.window_frame = {
  inactive_titlebar_bg = 'none',
  active_titlebar_bg = 'none',
}

config.use_ime = true
return config
