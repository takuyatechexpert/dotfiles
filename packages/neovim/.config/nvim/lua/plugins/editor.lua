return {
  -- indent
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
      local hooks = require('ibl.hooks')
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        -- インデントガイド: 控えめな背景色（スペース文字には bg が必要）
        vim.api.nvim_set_hl(0, 'IblIndent', { bg = '#3a3634', nocombine = true })
        -- スコープ: 少し明るめの背景色
        vim.api.nvim_set_hl(0, 'IblScope',  { bg = '#4a4340', nocombine = true })
      end)
      require('ibl').setup({
        indent = { char = ' ', highlight = 'IblIndent' },
        scope  = { enabled = true, highlight = 'IblScope' },
      })
    end,
  },

  -- extra space
  'bronson/vim-trailing-whitespace',

  -- surround
  'tpope/vim-surround',

  -- comment
  {
    'numToStr/Comment.nvim',
    opts = {},
    lazy = false,
  },

  -- vim mode line decorations
  {
    'mvllow/modes.nvim',
    tag = 'v0.2.0',
    config = function()
      require('modes').setup()
    end,
  },

  -- which-key
  {
    "folke/which-key.nvim",
    lazy = true,
    config = function()
        local wk = require("which-key")
        wk.register({
            -- 新しい仕様に基づいたマッピング
            { "gm", group = "Copilot Chat" },
            { "gmd", desc = "Show diff" },
            { "gmp", desc = "System prompt" },

            { "gms", desc = "Show selection" },
            { "gmy", desc = "Yank diff" },
        }, { mode = "n" })
    end,
  },
}
