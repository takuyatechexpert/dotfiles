local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path
  })
end

require('packer').startup(function(use)
  -- lsp
  use 'wbthomason/packer.nvim'
  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'

  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/cmp-buffer'

  use 'hrsh7th/vim-vsnip'

  -- auto tag pairs
  use 'jiangmiao/auto-pairs'

  -- git
  use 'tpope/vim-fugitive'
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }

  -- extra space
  use 'bronson/vim-trailing-whitespace'
  use 'itchyny/lightline.vim'
  use 'itchyny/vim-gitbranch'
  use 'sainnhe/gruvbox-material'
  use 'tpope/vim-commentary'
  use 'tpope/vim-surround'

  use { 'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    cinfig = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = {
          "lua",
          "vim",

          "html",
          "javascript",
          "typescript",
          "tsx",
          "svelte",
          "vue",
          "astro",
          "prisma",
          "graphql",

          "php",
          "dart",
          "php",
          "go",
          "gomod",
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
      }
    end
  }

  -- use 'folke/which-key.nvim'

  -- fzf
  use { 'junegunn/fzf', dir = '~/.fzf', run = './install --all' }
  use { 'junegunn/fzf.vim' }

  -- zsh
  use 'zsh-users/zsh-autosuggestions'
  use 'zsh-users/zsh-syntax-highlighting'

  if packer_bootstrap then
    require('packer').sync()
  end
end)

local present1 = pcall(require, "lspconfig")
local present2, lsp_installer_servers = pcall(require, "nvim-lsp-installer.servers")

if not present1 or not present2 then return end

-- LSP servers to install
local lsp_servers = {
  "volar",
  "emmet_ls",
  "eslint",
  "intelephense",
  "html",
  "cssls",
  "tsserver",
  "tailwindcss",
  "sumneko_lua",
  "gopls",
  "prismals",
}

vim.cmd([[autocmd BufWritePost init.lua source <afile> | PackerCompile]])

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  -- eslint
  buf_set_keymap('n', '<leader>lk', '<cmd>EslintFixAll<CR>', opts)
end

local lsp_installer = require('nvim-lsp-installer')
lsp_installer.on_server_ready(function(server)
    local opts = {}
    opts.on_attach = on_attach

    -- snippet
    opts.capabilities = require('cmp_nvim_lsp')
      .default_capabilities(vim.lsp.protocol.make_client_capabilities())
    vim.opt.completeopt = 'menu,menuone,noselect'

    local cmp = require'cmp'
    cmp.setup({
      snippet = {
        expand = function(args)
          vim.fn['vsnip#anonymous'](args.body)
        end,
      },
      mapping = {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
      }, {
        { name = 'buffer' },
      })
    })

    server:setup(opts)
end)

local custom_configs = {
  sumneko_lua = function (config)
    config.settings = {
      Lua = {
        runtime = {
          -- LuaJIT in the case of Neovim
          version = "LuaJIT",
          path = vim.split(package.path, ';'),
        },

        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim", "hs" },
        },

        workspace = {
          -- Make the server aware of Neovim runtime files
          library = {
            unpack(vim.api.nvim_get_runtime_file("", true)),
            "/usr/lib/lua",
            "/usr/lib/lua-pam",
            "/usr/share/awesome/lib",
            "/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/",
          },
        },
      },
    }

    return config
  end,

  emmet_ls = function (config)
    config.filetypes = {
      "html",
      "css",
      "vue",
      "php",
    }

    return config
  end,

  eslint = function (config)
    config.filetypes = {
      "javascript", "javascriptreact", "javascript.jsx",
      "typescript", "typescriptreact", "typescript.tsx",
      "vue",
    }

    config.on_attach = function (client, bufnr)
      -- neovim's LSP client does not currently support dynamic capabilities registration, so we need to set
      -- the resolved capabilities of the eslint server ourselves!
      client.resolved_capabilities.document_formatting = true
      on_attach(client, bufnr)
    end

    config.settings = {
      format = { enable = true }, -- this will enable formatting
    }

    return config
  end,
}

-- make config for a server
local make_config = function (server)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

  local config = {
    -- enable snippet support
    capabilities = capabilities,
    -- map buffer local keybindings when the language server attaches
    on_attach = on_attach,

    flags = { debounce_text_changes = 150 },
  }

  local apply_custom_config = custom_configs[server]

  if apply_custom_config ~= nil then
    config = apply_custom_config(config)
  end

  return config
end

-- Load LSP servers. If not found then install server
for _, server_name in ipairs(lsp_servers) do
  local available, server = lsp_installer_servers.get_server(server_name)

  if not available then return end

  server:on_ready(function ()
    local opts = make_config(server_name)
    server:setup(opts)
  end)

  -- Queue the server to be installed if not installed
  if not server:is_installed() then
    server:install()
  end
end
