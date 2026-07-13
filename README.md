# Neovim config — Zig-focused

A from-scratch Neovim setup optimized for Zig development on Windows.

## Toolchain (managed by scoop)

| Tool | Purpose |
|---|---|
| `neovim` | the editor |
| `zig` | compiler; also used to build treesitter parsers |
| `zls` | Zig language server (keep in lockstep with zig: `scoop update zig zls`) |
| `tree-sitter` | CLI used by nvim-treesitter to build parsers |
| `gcc` | C compiler for parser builds (config points `CC` at scoop's gcc) |
| `ripgrep`, `fd` | telescope live-grep / file finding |
| `JetBrainsMono-NF` | Nerd Font for icons — set it as your terminal font |

Mason additionally installs `lua-language-server`, `stylua` (for editing this
config) and `codelldb` (debugger) into `~/AppData/Local/nvim-data/mason`.

## What you get for Zig

- **zls**: completion, goto-def, rename, code actions, inlay hints,
  semantic highlighting, and **build-on-save**: `zig build` runs when you save
  and project-wide errors show as diagnostics.
  - Tip: add a `check` step to your `build.zig` and set
    `build_on_save_args = { 'check' }` in `lua/plugins/lsp.lua` for faster
    feedback without producing binaries.
- **Format on save** with `zig fmt` (conform.nvim).
- **Treesitter** highlighting (parsers built with the tree-sitter CLI + scoop's
  gcc — no MSVC needed).
- **Debugging** with nvim-dap + codelldb (`F5` to launch `zig-out/bin/...`).
- **Quickfix-integrated builds**: `<leader>zb` runs `:make` (`zig build`).

## Key bindings (leader = space)

| Keys | Action |
|---|---|
| `<leader>zb` / `zr` / `zt` | zig build / build run / build test |
| `gd` / `grr` / `gri` / `grt` | goto def / references / impl / type def |
| `grn` / `gra` | rename / code action |
| `K` | hover docs |
| `<leader>th` | toggle inlay hints |
| `<leader>sf` / `sg` / `sh` / `sk` | find files / live grep / help / keymaps |
| `<leader><leader>` | open buffers |
| `<leader>xx` / `xb` | diagnostics (Trouble) |
| `<leader>e` | toggle file tree sidebar (neo-tree, reveals current file) |
| `-` | file explorer, full window (oil.nvim — edit the fs like a buffer) |
| `<leader>hs` / `hr` / `hp` | stage / reset / preview git hunk |
| `F5` `F10` `F11` `<leader>db` | debug: continue / step over / step into / breakpoint |
| `<leader>f` | format buffer |
| `<Esc><Esc>` (terminal) | back to normal mode |

Completion: `<C-y>` accept, `<C-n>`/`<C-p>` select, `<C-space>` docs.

## Structure

```
init.lua                     entry point
lua/config/{options,keymaps,autocmds,lazy}.lua
lua/plugins/*.lua            one file per concern (lsp, dap, telescope, ...)
after/ftplugin/zig.lua       zig-specific keymaps + :compiler zig_build
```

## Maintenance

- `:Lazy update` — update plugins
- `:Mason` — manage lua_ls / stylua / codelldb
- `:checkhealth` — diagnose problems
- `scoop update zig zls neovim` — update the toolchain

The previous config was backed up to `nvim.bak-2025-kickstart` and
`nvim-data.bak-2025-kickstart` next to this directory.
