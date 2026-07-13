-- Neovim config focused on Zig development.
-- zig + zls are installed via scoop; everything else bootstraps itself.

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to false if your terminal font is not a Nerd Font
vim.g.have_nerd_font = true

require('config.options')
require('config.keymaps')
require('config.autocmds')
require('config.lazy')
