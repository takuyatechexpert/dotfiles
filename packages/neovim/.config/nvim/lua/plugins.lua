return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {
        'williamboman/mason.nvim',
        build = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'L3MON4D3/LuaSnip'},
    },
    config = function()
      require('config/lspconfig')
    end
  },
  -- auto tag pairs
  'jiangmiao/auto-pairs',
  -- auto tag pairs
  'jiangmiao/auto-pairs',

  -- git
  'tpope/vim-fugitive',
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  },

  -- extra space
  'bronson/vim-trailing-whitespace',
  'itchyny/lightline.vim',
  'itchyny/vim-gitbranch',
  'sainnhe/gruvbox-material',
  'tpope/vim-commentary',
  'tpope/vim-surround',

  'sheerun/vim-polyglot',

  {
    "folke/which-key.nvim",
    lazy = true
  },

  -- fzf
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('config/telescope')
    end
  },
  {
    'junegunn/fzf',
    dir = '~/.fzf',
    run = './install --all',
  },

  -- zsh
  'zsh-users/zsh-autosuggestions',
  'zsh-users/zsh-syntax-highlighting',
}
