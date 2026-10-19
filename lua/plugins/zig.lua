return {
  {
    "ziglang/zig.vim",
    ft = { "zig", "zir" },
    init = function()
      -- Off because conform.nvim already runs zig fmt on save.
      vim.g.zig_fmt_autosave = 0
      vim.g.zig_fmt_parse_errors = 1
    end,
  },
}
