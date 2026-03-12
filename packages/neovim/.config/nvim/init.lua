vim.loader.enable()

-- Disable netrw to use oil.nvim as default file explorer
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local cmd = vim.cmd

if vim.fn.has('nvim') == 1 then
cmd('source ' .. '~/dotfiles/packages/vim/.vim/basic.vim')
end

require('lazy_nvim')

-- Ctrl+Z でフローティングターミナルをトグル
local floating_term_buf = nil
local floating_term_win = nil

local function toggle_floating_terminal()
  if floating_term_win and vim.api.nvim_win_is_valid(floating_term_win) then
    vim.api.nvim_win_close(floating_term_win, true)
    floating_term_win = nil
    return
  end

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  if not floating_term_buf or not vim.api.nvim_buf_is_valid(floating_term_buf) then
    floating_term_buf = vim.api.nvim_create_buf(false, true)
  end

  floating_term_win = vim.api.nvim_open_win(floating_term_buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })

  if vim.bo[floating_term_buf].buftype ~= 'terminal' then
    vim.cmd('terminal')
  end

  vim.cmd('startinsert')
end

vim.keymap.set({'n', 't'}, '<C-z>', toggle_floating_terminal, { noremap = true, silent = true, desc = 'Toggle floating terminal' })
