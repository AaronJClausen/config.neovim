-- Editor options

-- Disable unused legacy providers (silences :checkhealth warnings)
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false -- statusline shows the mode already

-- Sync with system clipboard (scheduled to avoid slowing startup)
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = true
vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 400

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.inccommand = 'split' -- live preview of :s substitutions
vim.o.cursorline = true
vim.o.scrolloff = 8
vim.o.confirm = true -- ask instead of failing on unsaved changes
vim.o.winborder = 'rounded'

-- zig fmt uses 4-space indentation
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4

vim.diagnostic.config {
  severity_sort = true,
  float = { source = 'if_many' },
  virtual_text = { source = 'if_many', spacing = 2 },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
}
