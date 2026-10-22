# AGENTS.md

Personal Neovim config, forked from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).
It branched off upstream at `3338d39` (May 2025). Every commit after that is the user's own
(`git log 3338d39..HEAD`). Upstream has since been rewritten (it moved from lazy.nvim to `vim.pack`,
switched to mini.icons, and split init.lua into new sections), so **don't port upstream changes
wholesale**. Diff against `3338d39` to see what the user changed.

## Layout

- `init.lua`: almost everything (options, keymaps, the lazy.nvim bootstrap, and all core plugin
  specs: telescope, LSP, conform, blink.cmp, treesitter, mini, etc.), in kickstart's heavily commented
  single-file style.
- `lua/kickstart/plugins/*.lua`: kickstart's optional plugins, enabled by `require 'kickstart.plugins.<name>'`
  near the end of init.lua. Only **neo-tree** is enabled. debug, indent_line, lint, autopairs and gitsigns
  are still commented out.
- `lua/custom/plugins/*.lua`: the user's own plugins, loaded via `{ import = 'custom.plugins' }`.
- `lua/kickstart/health.lua`: `:checkhealth kickstart`.
- `lazy-lock.json`: plugin pins. **It is gitignored** (not tracked), as are `.luarc.json`, `spell/`, `.DS_Store`.
- `Usermanual.md`: the user's personal cheat sheet (see below).
- `.stylua.toml`: formatting rules. `doc/kickstart.txt`: help file.

## Deviations from upstream kickstart

Meaningful changes:

- **LSP setup migrated to mason-lspconfig v2 / native `vim.lsp.config`.** The old `handlers` callback is
  gone. init.lua now calls `vim.lsp.config('*', { capabilities = ... })`, then `vim.lsp.config(name, cfg)`
  for each entry in `servers`, then `vim.lsp.enable(vim.tbl_keys(servers))`. Per-server settings go in the
  `servers` table.
- **Servers:** `gopls`, `ty` + `ruff` (Python; ruff's hover is disabled so ty provides it; this replaced
  pyright), `rust_analyzer`, `bashls`, `ts_ls`, `lua_ls`.
- **rust_analyzer comes from rustup, not Mason.** Its `cmd` is `~/.cargo/bin/rust-analyzer`, and it is
  filtered out of Mason's `ensure_installed`, because Mason's build drifts out of sync with `rust-src`.
  Keep it that way.
- **LSP keymaps simplified.** The Neovim 0.11 defaults `grn/gra/grr/gri/grt` are deleted in `LspAttach`.
  The replacements are `gn` rename, `ga` code action, `gr` references, `gi` implementation, `gd` definition.
- **neo-tree enabled.** `<leader>e` toggles it (upstream used `\` to reveal).
- **Custom plugins** (`lua/custom/plugins/`):
  - `bufferline.lua`: buffers shown as tabs, ordinal numbers, text-only. Keys: `<S-h>`/`<S-l>` to cycle,
    `<leader>bd` to delete, `<leader>bp` to pin, `<leader>1`..`9` to jump. It also **overrides `<CR>` in
    cmdline mode**: a bare `:q` runs `:bd` when more than one listed buffer is open, otherwise it quits
    (`:q!`, `:wq`, `:qa` behave as normal).
  - `log-highlighting.lua`: `MTDL9/vim-log-highlighting`, plus filetype detection for `*.log` and `*.log.N`.
  - `lsp-file-operations.lua`: renames in neo-tree send `workspace/willRenameFiles` to the LSP. Its
    `default_capabilities()` are merged into the LSP capabilities in init.lua.

Minor changes:

- Options: `tabstop`/`shiftwidth` = 4, `expandtab`, `termguicolors`. `have_nerd_font` is still `false`.
- Telescope: `<leader><leader>` finds files, `<leader><Tab>` lists buffers (upstream used `<leader><leader>`
  for buffers).
- blink.cmp keymap preset is `'enter'` (Enter accepts).
- Colorscheme: `navarasu/onedark.nvim` (style `dark`) replaces tokyonight.
- Treesitter: `main = 'nvim-treesitter.config'` (the plugin tracks the `main` branch), and `wgsl` was added
  to `ensure_installed`.

## Conventions

- Lua is formatted with **stylua** per `.stylua.toml`: 2-space indent, single quotes, no call parentheses
  (`require 'x'`, `setup { ... }`), 160 columns. `.github/workflows/stylua.yml` runs `stylua --check .`,
  but it is guarded by `github.repository == 'nvim-lua/kickstart.nvim'`, so it doesn't run on this fork.
  Run the check locally.
- **New plugins** go in a new file under `lua/custom/plugins/` that returns a lazy.nvim spec. Put a short
  header comment with the plugin URL and the reason it was added, like the existing files. Only edit
  init.lua when you need to change a core plugin's config.
- **External tools** (LSP servers, formatters, linters) are installed by mason-tool-installer.
  `ensure_installed` is built from the keys of `servers` (minus `rust_analyzer`) plus the extra list in
  init.lua. Add formatters such as `stylua` to that list. Mason binaries live in
  `~/.local/share/nvim/mason/bin/`.
- Keep kickstart's explanatory comment style. Explain *why* a deviation exists in a comment.
- Leader is `<Space>`. Add `desc` to every keymap so it shows up in which-key.

## User manual (`Usermanual.md`)

`Usermanual.md` is the user's personal cheat sheet. It deliberately lists **only** the shortcuts and
commands the user has asked about because they couldn't remember them, not every keymap in the config.

- **When the user asks how to do something** ("what's the shortcut for X?", "how do I Y?"), answer, then
  add the answer to `Usermanual.md` under a fitting section (create the section if needed). Skip it if it's
  already there. Don't add entries the user didn't ask about.
- **Keep it in sync.** Whenever you add, change or remove a keymap, command or plugin, check whether any
  `Usermanual.md` entry is affected and update or remove it in the same change. Verify entries against the
  actual config (or `maparg()` headless) rather than assuming upstream defaults.
- Format: a table per section with `Keys` / `Mode` / `What it does` columns. Note where a mapping comes
  from when it isn't obvious (e.g. "built-in", "mini.surround").

## Formatting

conform.nvim, configured in init.lua. `<leader>f` formats the buffer, and files are also formatted on
save, falling back to the LSP formatter (`lsp_format = 'fallback'`). Per-filetype formatters are listed in
`formatters_by_ft`.

## Verifying changes

All of these were tested with Neovim 0.13-dev:

```sh
nvim --headless +qa                                   # startup: any Lua error is printed to stderr
~/.local/share/nvim/mason/bin/stylua --check .        # formatting (stylua isn't on $PATH)
nvim --headless "+checkhealth" "+w! /tmp/health.txt" +qa   # plain "+checkhealth" +qa shows only progress
grep -nE 'ERROR|WARNING' /tmp/health.txt
nvim --headless "+Lazy! install" +qa                  # install missing plugins only
```

`nvim --headless "+Lazy! sync" +qa` also works, but it **updates** every plugin and rewrites
`lazy-lock.json`. Only run it when the user wants an update. To check that a server attaches, open a file
headless and inspect `vim.lsp.get_clients()`.
