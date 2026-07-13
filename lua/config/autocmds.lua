-- Autocommands

local augroup = function(name)
  return vim.api.nvim_create_augroup('user_' .. name, { clear = true })
end

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup 'highlight_yank',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Restore cursor position when reopening a file
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup 'restore_cursor',
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Terminal buffers: no line numbers, start in insert mode
vim.api.nvim_create_autocmd('TermOpen', {
  group = augroup 'terminal',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = 'no'
    vim.cmd.startinsert()
  end,
})
