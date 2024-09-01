local lsp = require('lsp-zero')

-- extend_lspconfigを呼び出してlspconfigを拡張
lsp.extend_lspconfig()

-- lsp-compeプリセットを設定する
lsp.preset('lsp-compe')

-- LSPアタッチ時の設定
lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

-- masonの設定
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
    "volar",
    "emmet_ls",
    "eslint",
    -- "intelephense",
    "html",
    "cssls",
    "tsserver",
    "tailwindcss",
    "graphql",
    "lua_ls",
    "prismals",
    "svelte",
  },
  handlers = {
    lsp.default_setup,
    lua_ls = function()
      local lua_opts = lsp.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)
    end,
  }
})

-- LSP設定
local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config

-- cmp-nvim-lspで設定されるcapabilitiesを統合
lsp_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lsp_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- LspAttachイベントでのキー設定
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = true}

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
    vim.keymap.set('n', '<space>f', vim.lsp.buf.format, opts)

    -- eslint
    vim.keymap.set('n', '<leader>lk', '<cmd>EslintFixAll<CR>', opts)
  end
})

-- 自動補完の設定
local cmp = require('cmp')
local cmp_format = require('lsp-zero').cmp_format()

cmp.setup({
  formatting = cmp_format,
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({select = false}),
  })
})

-- LSPサーバーの設定
lspconfig.tsserver.setup({})
lspconfig.eslint.setup({})

-- lsp-zeroのセットアップ
lsp.setup()
