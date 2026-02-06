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

  -- git cppilot
  {
    'github/copilot.vim',
    lazy=false,
  },

  -- color scheme
  {'sainnhe/gruvbox-material',
    config = function()
      vim.cmd('colorscheme gruvbox-material')
    end
  },

  -- AI assistant
  -- claude code
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = function()
      require("claudecode").setup({
        terminal = {
          split_side = "right",
          split_width_percentage = 0.40,
        },
      })
    end,
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
      -- Window size adjustment
      {
        "<leader>ch",
        "<cmd>execute 'wincmd l | vertical resize +10 | wincmd p'<cr>",
        desc = "Increase Claude Code width by 10 columns"
      },
      {
        "<leader>cl",
        "<cmd>execute 'wincmd l | vertical resize -10 | wincmd p'<cr>",
        desc = "Decrease Claude Code width by 10 columns"
      },
    },
  },

  -- copilot chat
  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   dependencies = {
  --     { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
  --     { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
  --   },
  --   opts = {
  --     debug = true, -- Enable debugging
  --     -- See Configuration section for rest
  --     prompts = {
  --       -- Code related prompts
  --       Explain = "次のコードがどのように機能するかを説明してください。",
  --       Review = "次のコードを確認し、改善のための提案を提供してください。",
  --       Tests = "選択したコードがどのように機能するかを説明し、テストを生成してください。",
  --       Refactor = "次のコードをリファクタリングして、明確さと効率性を向上させてください。",
  --       FixCode = "意図したとおりに動作するように、次のコードを修正してください。",
  --       FixError = "次のテキストでエラーを説明し、解決策を提供してください。",
  --       BetterNamings = "次の変数とと関数に適切な名前を付けてください。",
  --       Documentation = "次のコードのドキュメントを提供してください。",
  --       SwaggerApiDocs = "Swaggerを使用して、次のAPIのドキュメントを提供してください。",
  --       SwaggerJsDocs = "Swaggerを使用して、次のAPIのドキュメントを提供してください。",
  --       -- Text related prompts
  --       Summarize = "次の文章を要約してください。",
  --       Spelling = "次の文章の文法およびスペルを修正してください。",
  --       Wording = "次の文章の文法と表現を改善してください。",
  --       Concise = "次の文章をより簡潔に書き直してください。",
  --     },
  --   },
  --   -- See Commands section for default commands if you want to lazy load on them
  --   config = function(_, opts)
  --     local chat = require("CopilotChat")
  --     local select = require("CopilotChat.select")
  --     -- Use unnamed register for the selection
  --     opts.selection = select.unnamed
  --
  --     -- Override the git prompts message
  --     opts.prompts.Commit = {
  --       prompt = "Write commit message for the change with commitizen convention",
  --       selection = select.gitdiff,
  --     }
  --     opts.prompts.CommitStaged = {
  --       prompt = "Write commit message for the change with commitizen convention",
  --       selection = function(source)
  --         return select.gitdiff(source, true)
  --       end,
  --     }
  --
  --     chat.setup(opts)
  --
  --     vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
  --       chat.ask(args.args, { selection = select.visual })
  --     end, { nargs = "*", range = true })
  --
  --     -- Inline chat with Copilot
  --     vim.api.nvim_create_user_command("CopilotChatInline", function(args)
  --       chat.ask(args.args, {
  --         selection = select.visual,
  --         window = {
  --           layout = "float",
  --           relative = "cursor",
  --           width = 1,
  --           height = 0.4,
  --           row = 1,
  --         },
  --       })
  --     end, { nargs = "*", range = true })
  --
  --     -- Restore CopilotChatBuffer
  --     vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
  --       chat.ask(args.args, { selection = select.buffer })
  --     end, { nargs = "*", range = true })
  --
  --     -- Custom buffer for CopilotChat
  --     vim.api.nvim_create_autocmd("BufEnter", {
  --       pattern = "copilot-*",
  --       callback = function()
  --         vim.opt_local.relativenumber = true
  --         vim.opt_local.number = true
  --
  --         -- Get current filetype and set it to markdown if the current filetype is copilot-chat
  --         local ft = vim.bo.filetype
  --         if ft == "copilot-chat" then
  --           vim.bo.filetype = "markdown"
  --         end
  --       end,
  --     })
  --
  --     -- Add which-key mappings
  --     local wk = require("which-key")
  --     wk.register({
  --       g = {
  --         m = {
  --           name = "+Copilot Chat",
  --           d = "Show diff",
  --           p = "System prompt",
  --           s = "Show selection",
  --           y = "Yank diff",
  --         },
  --       },
  --     })
  --   end,
  --   event = "VeryLazy",
  --   keys = {
  --     -- Show help actions with telescope
  --     {
  --       "<leader>ah",
  --       function()
  --         local actions = require("CopilotChat.actions")
  --         require("CopilotChat.integrations.telescope").pick(actions.help_actions())
  --       end,
  --       desc = "CopilotChat - Help actions",
  --     },
  --     -- Show prompts actions with telescope
  --     {
  --       "<leader>ap",
  --       function()
  --         local actions = require("CopilotChat.actions")
  --         require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
  --       end,
  --       desc = "CopilotChat - Prompt actions",
  --     },
  --     {
  --       "<leader>ap",
  --       ":lua require('CopilotChat.integrations.telescope').pick(require('CopilotChat.actions').prompt_actions({selection = require('CopilotChat.select').visual}))<CR>",
  --       mode = "x",
  --       desc = "CopilotChat - Prompt actions",
  --     },
  --     -- Code related commands
  --     { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
  --     { "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
  --     { "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
  --     { "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
  --     { "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
  --     -- Chat with Copilot in visual mode
  --     {
  --       "<leader>av",
  --       ":CopilotChatVisual",
  --       mode = "x",
  --       desc = "CopilotChat - Open in vertical split",
  --     },
  --     {
  --       "<leader>ax",
  --       ":CopilotChatInline<cr>",
  --       mode = "x",
  --       desc = "CopilotChat - Inline chat",
  --     },
  --     -- Custom input for CopilotChat
  --     {
  --       "<leader>ai",
  --       function()
  --         local input = vim.fn.input("Ask Copilot: ")
  --         if input ~= "" then
  --           vim.cmd("CopilotChat " .. input)
  --         end
  --       end,
  --       desc = "CopilotChat - Ask input",
  --     },
  --     -- Generate commit message based on the git diff
  --     {
  --       "<leader>am",
  --       "<cmd>CopilotChatCommit<cr>",
  --       desc = "CopilotChat - Generate commit message for all changes",
  --     },
  --     {
  --       "<leader>aM",
  --       "<cmd>CopilotChatCommitStaged<cr>",
  --       desc = "CopilotChat - Generate commit message for staged changes",
  --     },
  --     -- Quick chat with Copilot
  --     {
  --       "<leader>aq",
  --       function()
  --         local input = vim.fn.input("Quick Chat: ")
  --         if input ~= "" then
  --           vim.cmd("CopilotChatBuffer " .. input)
  --         end
  --       end,
  --       desc = "CopilotChat - Quick chat",
  --     },
  --     -- Debug
  --     { "<leader>ad", "<cmd>CopilotChatDebugInfo<cr>", desc = "CopilotChat - Debug Info" },
  --     -- Fix the issue with diagnostic
  --     { "<leader>af", "<cmd>CopilotChatFixDiagnostic<cr>", desc = "CopilotChat - Fix Diagnostic" },
  --     -- Clear buffer and chat history
  --     { "<leader>al", "<cmd>CopilotChatReset<cr>", desc = "CopilotChat - Clear buffer and chat history" },
  --     -- Toggle Copilot Chat Vsplit
  --     { "<leader>av", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle" },
  --   },
  -- },

  -- markdown preview
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {},
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ft = { "markdown" },
    keys = {
      { "<leader>mp", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown Preview" },
    },
  },

  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    ft = { "markdown" },
    config = function()
      require("peek").setup()
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
    keys = {
      { "<leader>mo", "<cmd>PeekOpen<cr>", desc = "Open Markdown Preview (Browser)" },
      { "<leader>mc", "<cmd>PeekClose<cr>", desc = "Close Markdown Preview (Browser)" },
    },
  },

  -- indent
  'Yggdroot/indentLine',

  -- git
  -- このプラグインは、Neovim用のGitインターフェースを提供します。Gitリポジトリ内での変更点の表示や、差分の確認、コミット履歴の閲覧など、Git操作をNeovim内で簡単に行うことができます。設定オプションを使用して、キーマッピングや表示方法をカスタマイズすることも可能です。
  {
    'dinhhuy258/git.nvim',
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

  -- extra space
  'bronson/vim-trailing-whitespace',
  'itchyny/vim-gitbranch',
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

  {
    'lewis6991/gitsigns.nvim',
    config = function()
      vim.defer_fn(function()
        require('gitsigns').setup {
        }
      end, 200)
    end
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
    -- event = { "BufReadPost", "BufNewFile" },
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

        "markdown",
        "markdown_inline",
      },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
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
      vim.cmd [[autocmd BufRead,BufEnter *.astro set filetype=astro]]
    end,
  },

  {
    'saghen/blink.cmp',
    lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    dependencies = 'rafamadriz/friendly-snippets',

    -- use a release tag to download pre-built binaries
    version = 'v0.*',
    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    opts = {
      keymap = { preset = 'default' },

      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing to ensure icons are aligned
      -- nerd_font_variant = 'normal',

      -- experimental auto-brackets support
      -- accept = { auto_brackets = { enabled = true } }

      -- experimental signature help support
      -- trigger = { signature_help = { enabled = true } }
    }
  },

  -- このプラグインは、Neovim用のキーバインディングヘルパーです。ユーザーがキーボードショートカットを入力すると、利用可能なコマンドやオプションの一覧をポップアップ表示します。これにより、複雑なキーマッピングを覚える必要がなくなり、効率的に操作できるようになります。設定オプションを使用して、表示方法やキーマッピングをカスタマイズすることも可能です。
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
        }, { mode = "n" })  -- ノーマルモードでの登録
    end
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
}
