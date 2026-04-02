return {
  {
    'dinhhuy258/git.nvim',
    config = function()
      require('git').setup({
        -- NOTE: `quit_blame` and `blame_commit` are still merged to the keymaps even if `default_mappings = false`
        default_mappings = true,

        keymaps = {
          -- Open blame commit
          diff = "<Leader>gd",
          -- Close git diff
          diff_close = "<Leader>gD",
        },
      })
    end,
  },

  'itchyny/vim-gitbranch',

  {
    'lewis6991/gitsigns.nvim',
    config = function()
      vim.defer_fn(function()
        require('gitsigns').setup {}
      end, 200)
    end,
  },
}
