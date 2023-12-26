return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    config = function()
      require('config/lspconfig')
    end,
  },
    -- LSP Support
  {'neovim/nvim-lspconfig'},
  {'williamboman/mason.nvim'},
  {'williamboman/mason-lspconfig.nvim'},

  -- Autocompletion
  {'hrsh7th/nvim-cmp'},
  {'hrsh7th/cmp-nvim-lsp'},
  {'L3MON4D3/LuaSnip'},

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

  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "lua",
        "vim",
        "nix",

        "html",
        "javascript",
        "typescript",
        "tsx",
        "vue",
        "svelte",
        "astro",
        "prisma",
        "graphql",

        "dart",
        "php",
        "go",
        "gomod",
      },

      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },

      highlight = {
        enable = true,
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection    = "gnn",
          node_incremental  = "grn",
          scope_incremental = "grc",
          node_decremental  = "grm",
        },
      },

      indent = {
        enable = true,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

      parser_config.blade = {
          install_info = {
              url = "https://github.com/EmranMR/tree-sitter-blade",
              files = {"src/parser.c"},
              branch = "main",
          },
          filetype = "blade"
      }

      -- Automatically set syntax for astro files
      vim.cmd "autocmd BufRead,BufEnter *.astro set filetype=astro"
    end,
  },

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
