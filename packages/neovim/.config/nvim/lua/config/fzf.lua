local opts = { noremap = true, silent = true }
local fzf = require('fzf-lua')

fzf.setup({})

vim.keymap.set('n', '<leader>ff', fzf.files, opts)
vim.keymap.set('n', '<leader>fa', function() fzf.files({ hidden = true }) end, opts)
vim.keymap.set('n', '<leader>fg', fzf.live_grep, opts)
vim.keymap.set('n', '<leader>fb', fzf.buffers, opts)
vim.keymap.set('n', '<leader>fh', fzf.help_tags, opts)
