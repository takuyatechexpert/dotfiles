local wezterm = require 'wezterm'
local act = wezterm.action

local M = {}

--- タブ内の全ペインを均等サイズに調整する
-- 各境界の左(上)ペインをアクティブにして AdjustPaneSize で境界を移動させる
-- @param window  WezTerm window object
-- @param current_pane  現在アクティブなペイン
function M.equalize(window, current_pane)
  local tab = window:active_tab()
  local pane_list = tab:panes_with_info()
  if #pane_list <= 1 then return end

  local active_id = current_pane:pane_id()

  local function find_by_id(id)
    for _, p in ipairs(tab:panes_with_info()) do
      if p.pane:pane_id() == id then return p end
    end
  end

  -- 水平均等化: 行グループ（同じ top）ごとに左右幅を揃える
  local row_groups = {}
  for _, p in ipairs(pane_list) do
    local key = p.top
    if not row_groups[key] then row_groups[key] = {} end
    table.insert(row_groups[key], p)
  end

  for _, group in pairs(row_groups) do
    if #group <= 1 then goto next_row end
    table.sort(group, function(a, b) return a.left < b.left end)
    local n = #group
    local start = group[1].left
    local total = group[n].left + group[n].width - start
    local ids = {}
    for i, p in ipairs(group) do ids[i] = p.pane:pane_id() end

    for i = 1, n - 1 do
      local pi = find_by_id(ids[i])
      if not pi then goto next_h end
      local target = start + math.floor(total * i / n)
      local current = pi.left + pi.width
      local diff = target - current
      if diff ~= 0 then
        window:perform_action(act.ActivatePaneByIndex(pi.index), current_pane)
        if diff > 0 then
          window:perform_action(act.AdjustPaneSize { 'Right', diff }, current_pane)
        else
          window:perform_action(act.AdjustPaneSize { 'Left', -diff }, current_pane)
        end
      end
      ::next_h::
    end
    ::next_row::
  end

  -- 垂直均等化: 列グループ（同じ left）ごとに上下高さを揃える
  -- 水平調整後の座標で再取得
  pane_list = tab:panes_with_info()
  local col_groups = {}
  for _, p in ipairs(pane_list) do
    local key = p.left
    if not col_groups[key] then col_groups[key] = {} end
    table.insert(col_groups[key], p)
  end

  for _, group in pairs(col_groups) do
    if #group <= 1 then goto next_col end
    table.sort(group, function(a, b) return a.top < b.top end)
    local n = #group
    local start = group[1].top
    local total = group[n].top + group[n].height - start
    local ids = {}
    for i, p in ipairs(group) do ids[i] = p.pane:pane_id() end

    for i = 1, n - 1 do
      local pi = find_by_id(ids[i])
      if not pi then goto next_v end
      local target = start + math.floor(total * i / n)
      local current = pi.top + pi.height
      local diff = target - current
      if diff ~= 0 then
        window:perform_action(act.ActivatePaneByIndex(pi.index), current_pane)
        if diff > 0 then
          window:perform_action(act.AdjustPaneSize { 'Down', diff }, current_pane)
        else
          window:perform_action(act.AdjustPaneSize { 'Up', -diff }, current_pane)
        end
      end
      ::next_v::
    end
    ::next_col::
  end

  -- 元のアクティブペインに戻す
  local orig = find_by_id(active_id)
  if orig then
    window:perform_action(act.ActivatePaneByIndex(orig.index), current_pane)
  end
end

return M
