local cmd = vim.cmd

if vim.fn.has('nvim') == 1 then
cmd('source ' .. '~/dotfiles/packages/vim/.vim/basic.vim')
end

require('lazy_nvim')
