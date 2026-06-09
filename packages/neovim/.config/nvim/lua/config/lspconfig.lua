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
    "ts_ls",
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

-- blink.cmpで設定されるcapabilitiesを統合
lsp_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lsp_defaults.capabilities,
  require('blink.cmp').get_lsp_capabilities()
)

-- LspAttachイベントでのキー設定
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local bufnr = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then return end

    -- Neovim 0.11 系の `client:supports_method(method, bufnr)` と
    -- 旧来の `client.supports_method(method, { bufnr = bufnr })` の双方に対応
    local function supports(method)
      local ok, result = pcall(function()
        return client:supports_method(method, bufnr)
      end)
      if ok then return result end
      return client.supports_method(method, { bufnr = bufnr })
    end

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- メソッド対応LSPがある場合のみキーマップを登録
    -- （eslint等 definition 非対応サーバー単体でアタッチ時の "not supported" エラー回避）
    if supports('textDocument/declaration') then
      map('n', 'gD', vim.lsp.buf.declaration, 'LSP: Declaration')
    end
    if supports('textDocument/definition') then
      map('n', 'gd', vim.lsp.buf.definition, 'LSP: Definition')
    end
    if supports('textDocument/hover') then
      map('n', 'K', vim.lsp.buf.hover, 'LSP: Hover')
    end
    if supports('textDocument/implementation') then
      map('n', 'gi', vim.lsp.buf.implementation, 'LSP: Implementation')
    end
    if supports('textDocument/signatureHelp') then
      map('n', '<C-k>', vim.lsp.buf.signature_help, 'LSP: Signature help')
    end
    if supports('textDocument/typeDefinition') then
      map('n', '<space>D', vim.lsp.buf.type_definition, 'LSP: Type definition')
    end
    if supports('textDocument/rename') then
      map('n', '<space>rn', vim.lsp.buf.rename, 'LSP: Rename')
    end
    if supports('textDocument/codeAction') then
      map('n', '<space>ca', vim.lsp.buf.code_action, 'LSP: Code action')
    end
    if supports('textDocument/references') then
      map('n', 'gr', vim.lsp.buf.references, 'LSP: References')
    end
    if supports('textDocument/formatting') then
      map('n', '<space>f', vim.lsp.buf.format, 'LSP: Format')
    end

    -- workspace / diagnostic はメソッド依存ではないので無条件にバインド
    map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, 'LSP: Add workspace folder')
    map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, 'LSP: Remove workspace folder')
    map('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, 'LSP: List workspace folders')
    map('n', '<space>e', vim.diagnostic.open_float, 'Diagnostic: Float')
    map('n', '[d', vim.diagnostic.goto_prev, 'Diagnostic: Prev')
    map('n', ']d', vim.diagnostic.goto_next, 'Diagnostic: Next')
    map('n', '<space>q', vim.diagnostic.setloclist, 'Diagnostic: Loclist')

    -- eslint（eslint LSP がアタッチしているときだけ）
    if client.name == 'eslint' then
      map('n', '<leader>kl', '<cmd>EslintFixAll<CR>', 'ESLint: Fix all')
    end
  end
})

-- lsp-zeroのセットアップ
lsp.setup()
