return {
  -- Git signs in the gutter + hunk actions
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      on_attach = function(bufnr)
        local gs = require 'gitsigns'
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gs.nav_hunk 'next'
          end
        end, 'Next git change')
        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gs.nav_hunk 'prev'
          end
        end, 'Previous git change')
        map('n', '<leader>hs', gs.stage_hunk, 'Stage hunk')
        map('n', '<leader>hr', gs.reset_hunk, 'Reset hunk')
        map('n', '<leader>hp', gs.preview_hunk, 'Preview hunk')
        map('n', '<leader>hb', gs.blame_line, 'Blame line')
        map('n', '<leader>hd', gs.diffthis, 'Diff against index')
      end,
    },
  },

  -- Popup showing available keybindings as you type
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },
      spec = {
        { '<leader>s', group = 'Search' },
        { '<leader>z', group = 'Zig' },
        { '<leader>d', group = 'Debug' },
        { '<leader>h', group = 'Git hunk' },
        { '<leader>t', group = 'Toggle' },
        { '<leader>x', group = 'Diagnostics' },
      },
    },
  },

  -- Edit the filesystem like a buffer
  {
    'stevearc/oil.nvim',
    dependencies = { { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font } },
    lazy = false,
    keys = {
      { '-', '<cmd>Oil<CR>', desc = 'Open parent directory' },
    },
    opts = {
      view_options = { show_hidden = true },
    },
  },

  -- File tree sidebar on the left
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    cmd = 'Neotree',
    keys = {
      { '<leader>e', '<cmd>Neotree toggle reveal left<CR>', desc = 'File tree sidebar' },
    },
    opts = {
      close_if_last_window = true,
      filesystem = {
        filtered_items = { visible = true }, -- show dotfiles/gitignored, just dimmed
        follow_current_file = { enabled = true },
      },
    },
  },

  -- Pretty diagnostics/quickfix list
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    dependencies = { { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font } },
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xb', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = 'Buffer diagnostics (Trouble)' },
      { '<leader>xf', '<cmd>Trouble qflist toggle<CR>', desc = 'Quickfix list (Trouble)' },
    },
    opts = {},
  },

  -- Highlight TODO / FIXME / NOTE comments
  {
    'folke/todo-comments.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  -- Small quality-of-life modules
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.pairs').setup() -- auto-close brackets/quotes
      require('mini.surround').setup() -- sa/sd/sr to add/delete/replace surroundings
      require('mini.ai').setup { n_lines = 500 } -- better around/inside textobjects

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
}
