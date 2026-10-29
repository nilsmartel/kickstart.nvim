# User manual

Shortcuts and commands I keep forgetting. Only the ones I asked about, not everything in the config.

## Editing

| Keys            | Mode   | What it does                                                  |
| --------------- | ------ | ------------------------------------------------------------- |
| `gcc`           | Normal | Toggle comment on the current line (built-in, Neovim ≥ 0.10)  |
| `gc{motion}`    | Normal | Toggle comment over a motion, e.g. `gcip` (paragraph), `gc3j` |
| `gc`            | Visual | Toggle comment on the selection                               |
| `dgc` / `cgc`   | Normal | Delete / change the whole adjacent comment block (`gc` as text object) |

## Windows

| Keys                 | Mode   | What it does                                          |
| -------------------- | ------ | ----------------------------------------------------- |
| `<Space>h/j/k/l`     | Normal | Move focus to the left/lower/upper/right window       |
| `<C-h/j/k/l>`        | Normal | Same thing (kickstart default)                        |

## Docs / help

| Keys          | Mode   | What it does                                                                 |
| ------------- | ------ | ---------------------------------------------------------------------------- |
| `K`           | Normal | LSP hover docs for the symbol under the cursor (built-in). Press again to jump into the popup |
| `<Space>sh`   | Normal | Search Neovim's `:help` tags (Telescope)                                     |
| `<Space>sk`   | Normal | Search all keymaps (Telescope)                                               |
| `:h {topic}`  | Cmd    | Open Neovim help for a topic, e.g. `:h motion`                               |
