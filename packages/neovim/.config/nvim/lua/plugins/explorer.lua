return {
  {
    'stevearc/oil.nvim',
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('oil').setup({
        default_file_explorer = true,
        columns = {
          'icon',
          'permissions',
          'size',
          'mtime',
        },
        view_options = {
          show_hidden = true,
          is_hidden_file = function(name, bufnr)
            return vim.startswith(name, '.')
          end,
          is_always_hidden = function(name, bufnr)
            return false
          end,
        },
        skip_confirm_for_simple_edits = false,
        prompt_save_on_select_new_entry = true,
        keymaps = {
          ['g?'] = 'actions.show_help',
          ['<CR>'] = 'actions.select',
          ['<C-v>'] = { 'actions.select', opts = { vertical = true } },
          ['<C-\\>'] = { 'actions.select', opts = { horizontal = true } },
          ['<C-t>'] = { 'actions.select', opts = { tab = true } },
          ['<C-p>'] = 'actions.preview',
          ['<C-s>'] = false,
          ['<C-h>'] = false,
          ['<C-c>'] = 'actions.close',
          ['<C-r>'] = 'actions.refresh',
          ['-'] = 'actions.parent',
          ['_'] = 'actions.open_cwd',
          ['`'] = 'actions.cd',
          ['~'] = 'actions.tcd',
          ['gs'] = 'actions.change_sort',
          ['gx'] = 'actions.open_external',
          ['g.'] = 'actions.toggle_hidden',
          ['g\\'] = 'actions.toggle_trash',
        },
        use_default_keymaps = true,
      })

      -- Open oil.nvim when opening a directory
      vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
          local arg = vim.fn.argv(0)
          if arg and arg ~= '' and vim.fn.isdirectory(arg) == 1 then
            vim.cmd('Oil ' .. vim.fn.fnameescape(arg))
          end
        end,
      })

      -- Auto-refresh oil buffer when external changes may have occurred (e.g. files added by AI)
      -- FocusGained sets a flag, then oil refreshes on next BufEnter
      local oil_needs_refresh = false
      vim.api.nvim_create_autocmd('FocusGained', {
        callback = function()
          oil_needs_refresh = true
          if vim.bo.filetype == 'oil' then
            vim.schedule(function()
              require('oil.actions').refresh.callback()
              oil_needs_refresh = false
            end)
          end
        end,
      })
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = 'oil://*',
        callback = function()
          if oil_needs_refresh then
            oil_needs_refresh = false
            vim.schedule(function()
              require('oil.actions').refresh.callback()
            end)
          end
        end,
      })
    end,
    keys = {
      { '-', '<cmd>Oil<cr>', desc = 'Open parent directory' },
      { '<leader>e', '<cmd>Oil<cr>', desc = 'Open file explorer' },
    },
  },
}
