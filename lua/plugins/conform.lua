return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cF",
        function() require("conform").format({ async = true, lsp_fallback = true }) end,
        mode = { "n", "v" },
        desc = "Format (conform)",
      },
    },
    opts = {
      formatters_by_ft = {
        zig = { "zigfmt" },
        lua = { "stylua" },
      },
      format_on_save = function(bufnr)
        if vim.bo[bufnr].filetype == "zig" then
          return { timeout_ms = 2000, lsp_fallback = true }
        end
        return { timeout_ms = 500, lsp_fallback = true }
      end,
    },
  },
}
