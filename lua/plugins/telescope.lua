return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = { require('telescope.themes').get_dropdown() },
        },
      }
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      local map = vim.keymap.set
      map('n', '<leader>sf', builtin.find_files, { desc = 'Search files' })
      map('n', '<leader>sg', builtin.live_grep, { desc = 'Search by grep' })
      map('n', '<leader>sw', builtin.grep_string, { desc = 'Search current word' })
      map('n', '<leader>sh', builtin.help_tags, { desc = 'Search help' })
      map('n', '<leader>sk', builtin.keymaps, { desc = 'Search keymaps' })
      map('n', '<leader>sd', builtin.diagnostics, { desc = 'Search diagnostics' })
      map('n', '<leader>sr', builtin.resume, { desc = 'Resume last search' })
      map('n', '<leader>s.', builtin.oldfiles, { desc = 'Search recent files' })
      map('n', '<leader><leader>', builtin.buffers, { desc = 'Find open buffers' })
      map('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { winblend = 10, previewer = false })
      end, { desc = 'Fuzzy search current buffer' })
    end,
  },
}
