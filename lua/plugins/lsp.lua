return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )

      vim.diagnostic.config({
        virtual_text = { prefix = "●", source = "if_many" },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          local function map_buffer_key(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
          end

          map_buffer_key("n", "gd", vim.lsp.buf.definition, "Goto definition")
          map_buffer_key("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
          map_buffer_key("n", "gi", vim.lsp.buf.implementation, "Goto implementation")
          map_buffer_key("n", "gr", vim.lsp.buf.references, "References")
          map_buffer_key("n", "gy", vim.lsp.buf.type_definition, "Goto type definition")
          map_buffer_key("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end, "Hover")
          map_buffer_key("n", "<C-k>", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, "Signature help")
          map_buffer_key("i", "<C-k>", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, "Signature help")
          map_buffer_key("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
          map_buffer_key({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
          map_buffer_key("n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
          map_buffer_key("n", "<leader>cs", vim.lsp.buf.document_symbol, "Document symbols")
          map_buffer_key("n", "<leader>cS", vim.lsp.buf.workspace_symbol, "Workspace symbols")

          if client and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            map_buffer_key("n", "<leader>ch", function()
              vim.lsp.inlay_hint.enable(
                not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
                { bufnr = bufnr }
              )
            end, "Toggle inlay hints")
          end
        end,
      })

      vim.lsp.config("zls", {
        capabilities = capabilities,
        cmd = { "zls" },
        filetypes = { "zig", "zon" },
        root_markers = { "build.zig", "build.zig.zon", ".git" },
        settings = {
          zls = {
            enable_build_on_save = true,
            build_on_save_step = "check",
            enable_snippets = true,
            enable_argument_placeholders = true,
            enable_ast_check_diagnostics = true,
            enable_import_embedfile_argument_completions = true,
            warn_style = true,
            highlight_global_var_declarations = true,
            skip_std_references = false,
            prefer_ast_check_as_child_process = true,
            inlay_hints_show_variable_type_hints = true,
            inlay_hints_show_struct_literal_field_type = true,
            inlay_hints_show_parameter_name = true,
            inlay_hints_show_builtin = true,
            inlay_hints_exclude_single_argument = true,
            inlay_hints_hide_redundant_param_names = true,
            inlay_hints_hide_redundant_param_names_last_token = true,
            semantic_tokens = "full",
          },
        },
      })
      vim.lsp.enable("zls")

      if vim.fn.executable("lua-language-server") == 1 then
        vim.lsp.config("lua_ls", {
          capabilities = capabilities,
          cmd = { "lua-language-server" },
          filetypes = { "lua" },
          root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file("", true),
              },
              diagnostics = { globals = { "vim" } },
              telemetry = { enable = false },
            },
          },
        })
        vim.lsp.enable("lua_ls")
      end
    end,
  },
}
