-- Zig-specific buffer settings and keymaps

-- makeprg = zig build, with an errorformat that fills the quickfix list
vim.cmd.compiler 'zig_build'

local function map(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { buffer = true, desc = desc })
end

-- Build via :make so errors land in quickfix (]q / [q / <leader>xf to browse)
map('<leader>zb', '<cmd>make<CR>', 'zig build')

-- Run and test in a terminal split to see program/test output
map('<leader>zr', '<cmd>botright 15split | terminal zig build run<CR>', 'zig build run')
map('<leader>zt', '<cmd>botright 15split | terminal zig build test<CR>', 'zig build test')
