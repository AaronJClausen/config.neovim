return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      -- Parser builds need the tree-sitter CLI and a C compiler (both from
      -- scoop). Point CC at scoop's gcc explicitly: the mingw 13.x in
      -- C:\ProgramData\mingw64 can shadow it on PATH, and its ld cannot open
      -- the \\?\-prefixed output paths the tree-sitter CLI passes.
      if not vim.env.CC then
        local scoop_gcc = vim.fs.normalize '~/scoop/apps/gcc/current/bin/gcc.exe'
        if vim.uv.fs_stat(scoop_gcc) then
          vim.env.CC = scoop_gcc
        end
      end

      require('nvim-treesitter').install {
        'zig',
        'c',
        'lua',
        'luadoc',
        'vim',
        'vimdoc',
        'query',
        'markdown',
        'markdown_inline',
        'json',
        'toml',
        'yaml',
        'bash',
        'diff',
        'gitcommit',
        'regex',
      }

      -- Enable treesitter highlighting whenever a parser is available
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('user_treesitter', { clear = true }),
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },
}
