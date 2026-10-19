# Neovim config — Zig-focused

A lazy.nvim-based Neovim setup for Zig development, primarily used on Windows.

## Install

Clone into Neovim's config directory (`:echo stdpath('config')`):

```powershell
git clone https://github.com/AaronJClausen/config.neovim.git $env:LOCALAPPDATA\nvim
```

```sh
git clone https://github.com/AaronJClausen/config.neovim.git ~/.config/nvim
```

Plugins bootstrap themselves on first launch.

## Requirements

Everything is looked up on `PATH`; install it however you like (scoop, winget, a package manager, or from source).

| Tool | Needed for |
|---|---|
| Neovim 0.11+ | uses `vim.lsp.config` / `vim.lsp.enable` |
| `git` | lazy.nvim and plugin installs |
| `zig` | builds, `zig fmt`, and compiling treesitter parsers when no other C compiler is present |
| `zls` | Zig language server — keep it on the same version as `zig` |
| `ripgrep` | telescope live grep |
| A Nerd Font | icons — set it as your terminal font |

Optional — each feature quietly falls back or stays off without it:

| Tool | Enables |
|---|---|
| `pwsh` | used as Neovim's `shell` on Windows (otherwise `cmd.exe`) |
| `cmake` | builds telescope-fzf-native (faster sorting) |
| `make` | builds LuaSnip's jsregexp (snippet regex transforms) |
| `codelldb` (or `codelldb.cmd`) | debugging; or set `vim.g.codelldb_path` |
| `lua-language-server`, `stylua` | LSP and formatting while editing this config |

Treesitter parsers compile with the first of `$CC`, `cc`, `gcc`, `clang`, `cl`, `zig` found. After adding a parser to `ensure_installed`, install it once headlessly so it doesn't compile on startup:

```sh
nvim --headless "+TSUpdateSync <parser>" +qa
```

## Key bindings (leader = space)

| Keys | Action |
|---|---|
| `<leader>zb` / `zr` / `zt` | zig build / build run / build test |
| `<leader>zT` / `zR` / `zf` / `zc` | zig test / run / fmt / build-exe on the current file |
| `gd` / `gD` / `gi` / `gr` / `gy` | definition / declaration / implementation / references / type definition |
| `K` / `<C-k>` | hover / signature help |
| `<leader>cr` / `ca` / `cf` / `ch` | rename / code action / format / toggle inlay hints |
| `[d` / `]d` / `<leader>cd` | previous / next / line diagnostic |
| `<leader>ff` / `fg` / `fb` / `fr` / `fk` | find files / live grep / buffers / recent / keymaps |
| `<leader>e` / `<leader>o` | toggle / focus file tree |
| `]h` / `[h`, `<leader>gs` / `gr` / `gp` / `gb` | hunks: navigate, stage / reset / preview / blame |
| `<leader>xx` / `xX` / `xs` | Trouble: diagnostics / buffer diagnostics / symbols |
| `<leader>db` / `dc` / `di` / `do` / `du` | debug: breakpoint / continue / step into / step over / UI |
| `<leader>tt` / `th` / `tv`, `<C-\>` | floating / horizontal / vertical terminal |
| `<S-h>` / `<S-l>` / `<leader>bd` | previous / next / delete buffer |

Completion: `<Tab>` / `<S-Tab>` cycle, `<CR>` confirm, `<C-Space>` open, `<C-e>` abort.

## Maintenance

Background update checks are off; run `:Lazy check` / `:Lazy update` manually, and `:checkhealth` to diagnose problems.
