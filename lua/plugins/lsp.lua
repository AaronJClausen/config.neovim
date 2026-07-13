return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Mason manages tools that aren't installed via scoop (lua_ls, stylua, codelldb).
      -- zls itself comes from scoop so it always matches the scoop-installed zig.
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'saghen/blink.cmp',
      { 'j-hui/fidget.nvim', opts = {} }, -- LSP progress messages
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('user_lsp_attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local tb = require 'telescope.builtin'
          map('gd', tb.lsp_definitions, 'Goto definition')
          map('gD', vim.lsp.buf.declaration, 'Goto declaration')
          map('grr', tb.lsp_references, 'References')
          map('gri', tb.lsp_implementations, 'Goto implementation')
          map('grt', tb.lsp_type_definitions, 'Goto type definition')
          map('grn', vim.lsp.buf.rename, 'Rename')
          map('gra', vim.lsp.buf.code_action, 'Code action', { 'n', 'x' })
          map('gO', tb.lsp_document_symbols, 'Document symbols')
          map('gW', tb.lsp_dynamic_workspace_symbols, 'Workspace symbols')

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- Highlight other references of the symbol under the cursor
          if client and client:supports_method('textDocument/documentHighlight', event.buf) then
            local hl_group = vim.api.nvim_create_augroup('user_lsp_highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = hl_group,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = hl_group,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('user_lsp_detach', { clear = true }),
              callback = function(ev)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = hl_group, buffer = ev.buf }
              end,
            })
          end

          -- Inlay hints (zls provides parameter/type hints); toggle with <leader>th
          if client and client:supports_method('textDocument/inlayHint', event.buf) then
            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }, { bufnr = event.buf })
            end, 'Toggle inlay hints')
          end
        end,
      })

      -- Advertise blink.cmp completion capabilities to every server
      vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities() })

      -- zls: installed via scoop (version-locked to the scoop zig)
      vim.lsp.config('zls', {
        settings = {
          zls = {
            -- Run `zig build` on save and surface build errors as diagnostics.
            -- Tip: add a "check" step to build.zig and set
            -- build_on_save_args = { 'check' } for faster feedback.
            enable_build_on_save = true,
            semantic_tokens = 'full',
          },
        },
      })
      vim.lsp.enable 'zls'

      -- lua_ls: for editing this config
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            completion = { callSnippet = 'Replace' },
          },
        },
      })

      require('mason-tool-installer').setup {
        ensure_installed = { 'lua-language-server', 'stylua', 'codelldb' },
      }
      -- mason-lspconfig auto-enables servers installed through mason
      require('mason-lspconfig').setup()
    end,
  },
}
