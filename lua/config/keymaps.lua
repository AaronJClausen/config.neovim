-- Global keymaps (plugin-specific maps live with their plugin specs,
-- Zig-specific maps in after/ftplugin/zig.lua)

local map = vim.keymap.set

map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

map('n', '<leader>xq', vim.diagnostic.setloclist, { desc = 'Diagnostics to loclist' })

-- Easier terminal escape
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Move between windows with Ctrl+hjkl
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus upper window' })

-- Keep visual selection when indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Quickfix navigation (zig build errors land in quickfix)
map('n', ']q', '<cmd>cnext<CR>', { desc = 'Next quickfix item' })
map('n', '[q', '<cmd>cprev<CR>', { desc = 'Previous quickfix item' })
