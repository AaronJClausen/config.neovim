local ensure_installed_parsers = {
  "zig",
  "lua", "vim", "vimdoc", "query", "regex",
  "bash", "json", "yaml", "toml", "markdown", "markdown_inline",
  "c", "cpp", "diff", "gitcommit", "gitignore",
}

local function map_textobject_selection(lhs, capture)
  vim.keymap.set({ "x", "o" }, lhs, function()
    require("nvim-treesitter-textobjects.select").select_textobject(capture, "textobjects")
  end, { desc = "Select " .. capture })
end

local function map_textobject_jump(lhs, jump_function_name, capture)
  vim.keymap.set({ "n", "x", "o" }, lhs, function()
    require("nvim-treesitter-textobjects.move")[jump_function_name](capture, "textobjects")
  end, { desc = jump_function_name .. " " .. capture })
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- `master` is frozen and breaks on Neovim 0.12 (e.g. markdown injections error with
    -- "attempt to call method 'range'"). `main` does not support lazy-loading.
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install(ensure_installed_parsers)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_attach", { clear = true }),
        callback = function(ev)
          local has_parser = pcall(vim.treesitter.start, ev.buf)
          if has_parser then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      -- `an`/`in` are Neovim's built-in incremental node selection.
      vim.keymap.set("n", "<C-space>", "van", { remap = true, desc = "Start node selection" })
      vim.keymap.set("x", "<C-space>", "an", { remap = true, desc = "Grow node selection" })
      vim.keymap.set("x", "<bs>", "in", { remap = true, desc = "Shrink node selection" })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      map_textobject_selection("af", "@function.outer")
      map_textobject_selection("if", "@function.inner")
      map_textobject_selection("ac", "@class.outer")
      map_textobject_selection("ic", "@class.inner")
      map_textobject_selection("aa", "@parameter.outer")
      map_textobject_selection("ia", "@parameter.inner")

      map_textobject_jump("]f", "goto_next_start", "@function.outer")
      map_textobject_jump("]c", "goto_next_start", "@class.outer")
      map_textobject_jump("[f", "goto_previous_start", "@function.outer")
      map_textobject_jump("[c", "goto_previous_start", "@class.outer")
    end,
  },
}
