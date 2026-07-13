return {
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*', -- use a release so the prebuilt fuzzy-matcher binary is downloaded
    dependencies = {
      'rafamadriz/friendly-snippets',
      'folke/lazydev.nvim',
    },
    opts = {
      -- <C-y> accept, <C-space> open/toggle docs, <C-n>/<C-p> next/prev,
      -- <Tab>/<S-Tab> snippet jumps. See :h blink-cmp-keymap for the full list.
      keymap = { preset = 'default' },
      appearance = {
        nerd_font_variant = vim.g.have_nerd_font and 'mono' or 'normal',
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },
      signature = { enabled = true },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
  },

  -- Proper LSP support for editing this Neovim config
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
}
