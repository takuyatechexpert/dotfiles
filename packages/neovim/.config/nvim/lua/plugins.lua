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

  -- indent
  'Yggdroot/indentLine',

  -- git
  {
    'dinhhuy258/git.nvim',
    lazy = true,
    config = function ()
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
    end
  },

  {
    'lewis6991/gitsigns.nvim',
    config = function()
      vim.defer_fn(function()
        require('gitsigns').setup {
        }
      end, 200)
    end
  },

  -- extra space
  'bronson/vim-trailing-whitespace',
  'itchyny/vim-gitbranch',
  'sainnhe/gruvbox-material',
  'tpope/vim-surround',
  {
    'numToStr/Comment.nvim',
    opts = {
        -- add any options here
    },
    lazy = false,
  },

  -- vim mode line decorations
  {
    'mvllow/modes.nvim',
    tag = 'v0.2.0',
    config = function()
      require('modes').setup()
    end
  },

  -- vim noice
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
      }
  },

  {
    "nvim-lualine/lualine.nvim",
    enabled = true,
    event = "VeryLazy",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "gitsigns.nvim",
    },
    opts = function(_, opts)
        local disabled_filetypes = {
            "dap-repl",
            "dapui_breakpoints",
            "dapui_console",
            "dapui_scopes",
            "dapui_stacks",
            "dapui_watches",
            "mason",
            "NvimTree",
            "TelescopePrompt",
            "Trouble",
        }
        return vim.tbl_deep_extend("force", opts, {
            options = {
                icons_enabled = true,
                theme = "ayu_mirage", -- Use the catppuccin theme plugin.
                always_divide_middle = true,
                globalstatus = true,
            },
            disabled_filetypes = {
                statusline = disabled_filetypes,
                winbar = disabled_filetypes,
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {
                    {
                        "branch",
                        on_click = function()
                            vim.cmd("Telescope git_branches")
                        end,
                    },
                    {
                        "diff",
                        on_click = function()
                            require("gitsigns").diffthis()
                        end,
                    },
                    {
                        "diagnostics",
                        update_in_insert = true,
                        always_visible = false,
                        sources = { "nvim_diagnostic" },
                        on_click = function()
                            vim.cmd("TroubleToggle document_diagnostics")
                        end,
                    },
                },
                lualine_c = {
                    {
                        "filename",
                        file_status = true,
                        newfile_status = true,
                        path = 1, -- Show only the filename.
                    },
                },
                lualine_x = { "encoding", "filesize", "filetype", "fileformat" },
                lualine_y = { "searchcount", "progress" },
                lualine_z = { "location" },
            },
            extensions = { -- Enable integrations.
                "lazy",
                "nvim-dap-ui",
                "nvim-tree",
                "quickfix",
            },
        })
    end,
  },

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
    tag = '0.1.4',
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
