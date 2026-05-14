# Agent Guide for This Neovim Configuration

This is a **LazyVim**-based Neovim configuration. It is not a traditional software project with build/test scripts — "testing" means starting Neovim and verifying behavior manually.

## Essential Commands

| Command | Purpose |
|---------|---------|
| `nvim` | Start Neovim to test changes |
| `:Lazy` | Open plugin manager (install/update/sync plugins) |
| `:Lazy reload <plugin>` | Reload a plugin (triggers the custom theme hot-reload system) |
| `:checkhealth lazyvim` | Diagnose LazyVim issues |
| `stylua .` | Format all Lua files (see `stylua.toml`) |
| `stylua --check .` | Check formatting without writing |

## Project Structure

```
.
├── init.lua                    # Entry point: requires config.lazy
├── lua/
│   ├── config/
│   │   ├── lazy.lua            # Bootstraps lazy.nvim, loads LazyVim + custom plugins
│   │   ├── options.lua         # vim.opt overrides (loaded before lazy.nvim startup)
│   │   ├── keymaps.lua         # Keymaps (loaded on `VeryLazy` event)
│   │   └── autocmds.lua        # Autocommands (loaded on `VeryLazy` event)
│   └── plugins/                # Every `.lua` file here is auto-imported by lazy.nvim
│       ├── theme.lua           # Active colorscheme (github_dark_default)
│       ├── all-themes.lua      # Lazy-loaded theme plugins (available for hot-reload)
│       ├── omarchy-theme-hotreload.lua  # Custom theme reloading logic
│       ├── ruby.lua            # Ruby LSP, formatting, endwise
│       ├── gitsigns.lua        # Git blame on current line
│       ├── snacks-animated-scrolling-off.lua  # Snacks picker/scroll config
│       └── disable-news-alert.lua
├── plugin/after/transparency.lua   # Sets highlight groups transparent (bg = nil)
├── lazyvim.json                # Enabled LazyVim extras
└── stylua.toml                 # Lua formatter config
```

### How Files Are Loaded

- `init.lua` → `require("config.lazy")`
- `lua/config/lazy.lua` bootstraps lazy.nvim, imports `lazyvim.plugins`, then imports everything under `lua/plugins/`
- `lua/config/options.lua` is loaded **before** lazy.nvim startup
- `lua/config/keymaps.lua` and `lua/config/autocmds.lua` are loaded on the **`VeryLazy`** event (after UI)
- `plugin/after/*.lua` files are loaded by Neovim's standard `plugin/` runtime mechanism **after** `init.lua`

## Architecture & Control Flow

### Plugin Loading (lazy.nvim)

Every file in `lua/plugins/` is automatically imported. Each file must return a **plugin spec** (table or array of tables). Specs are merged with LazyVim defaults via `vim.tbl_deep_extend`. When overriding a plugin that LazyVim already configures (e.g., `neovim/nvim-lspconfig`), returning a spec with the same `_[1]_` (plugin name) merges/overrides rather than replacing.

**Important**: To completely replace a LazyVim default spec, use `opts = function(_, opts) ... end` to modify, or return a full `opts` table to override. To disable a plugin entirely: `{ "folke/trouble.nvim", enabled = false }`.

### Theme System (Non-Obvious)

The active theme is defined in `lua/plugins/theme.lua` (currently `github_dark_default`). There is a **custom hot-reload mechanism** in `lua/plugins/omarchy-theme-hotreload.lua` that:

1. Listens for `User LazyReload` autocommands
2. Unloads `package.loaded["plugins.theme"]`
3. Walks the plugin's `lua/` directory and clears **all** loaded modules for that plugin
4. Clears all highlight groups, resets syntax, resets `vim.o.background = "dark"`
5. Reloads `lua/plugins/theme.lua`, extracts the new `colorscheme`, and applies it
6. Re-sources `plugin/after/transparency.lua` after a defer

**Gotcha**: This hot-reload logic manually sources `plugin/after/transparency.lua`. If you add new `plugin/after/*.lua` files, they will **not** be automatically reloaded on theme change unless you modify `omarchy-theme-hotreload.lua`.

### Transparency

`plugin/after/transparency.lua` removes the `bg` attribute from ~50 highlight groups. It is loaded once at startup and re-sourced by the theme hot-reload system. It does **not** use a transparent-colorscheme option — it mutates highlight groups after the colorscheme is applied.

## Naming Conventions & Style

- **Indentation**: 2 spaces (StyLua enforces this; do not use tabs in Lua files)
- **Line width**: 120 columns (`stylua.toml`)
- **Plugin file naming**: kebab-case (e.g., `snacks-animated-scrolling-off.lua`)
- **Plugin specs**: Use explicit `name` when the repo name differs from the import module (e.g., `rose-pine/neovim` has `name = "rose-pine"`)

## LazyVim Extras Enabled

See `lazyvim.json`. Currently enabled extras:

- `lazyvim.plugins.extras.coding.yanky`
- `lazyvim.plugins.extras.editor.fzf`
- `lazyvim.plugins.extras.editor.neo-tree`
- `lazyvim.plugins.extras.editor.snacks_explorer`
- `lazyvim.plugins.extras.lang.elixir`
- `lazyvim.plugins.extras.lang.ruby`
- `lazyvim.plugins.extras.test.core`

Adding a new extra is done by editing `lazyvim.json` under the `"extras"` array, or by running `:LazyExtras` inside Neovim.

## Keymaps (Custom)

Defined in `lua/config/keymaps.lua`:

| Mode | Key | Action |
|------|-----|--------|
| `i` | `jk` | Escape to Normal mode |
| `n` | `<CR>` | Save current file (`:w`) |
| `n` | `<leader>cp` | Copy relative file path to clipboard |
| `n` | `<leader>bo` | Close all buffers except Snacks buffers |

Default LazyVim keymaps remain active. See [LazyVim keymaps docs](https://www.lazyvim.org/keymaps) for the full list.

## Language-Specific Configuration

### Ruby

- **LSP**: `ruby_lsp` (not installed via Mason; expects the gem on `$PATH`)
- **Formatter**: `standardrb` for `.rb`, `htmlbeautifier` for `.erb`
- **Endwise**: `tpope/vim-endwise` on `InsertEnter` for Ruby and other filetypes

### CSS/SCSS

- Formatted with `prettier` via `conform.nvim`

### Lua

- Formatted with `stylua`
- `lua_ls` is enabled via `.neoconf.json` for LSP completion of Neovim APIs

## Important Gotchas

1. **No Mason for ruby_lsp**: The Ruby LSP spec explicitly sets `mason = false`. If `ruby-lsp` is missing, install the gem globally or via bundler — Mason will not handle it.
2. **StyLua must be run manually**: There is no pre-commit hook or CI. Run `stylua .` before committing.
3. **Plugin/after loading order**: Files in `plugin/after/` are loaded by Neovim after `init.lua`, but the theme hot-reload system re-sources only `transparency.lua`. Changes to other `plugin/after/` files require restarting Neovim to take effect.
4. **Custom scroll disabled**: `snacks.nvim` scroll animation is explicitly disabled in `lua/plugins/snacks-animated-scrolling-off.lua`.
5. **News alerts disabled**: `lazyvim.json` + `disable-news-alert.lua` suppress startup news notifications.
6. **Picker hidden files**: Snacks picker is configured with `hidden = true` and `ignored = true` so dotfiles appear in file searches.
7. **Explorer on the right**: The snacks/neo-tree explorer layout is set to `position = "right"`, `width = 30`.

## Testing Changes

There is no automated test suite. Verify changes by:

1. Running `stylua --check .` to ensure formatting
2. Opening `nvim` and checking `:messages` for errors
3. Running `:Lazy sync` to ensure plugin specs are valid
4. For theme changes, run `:Lazy reload github-theme` (or the relevant plugin) and visually confirm
5. For keymap changes, test the mapping directly in a buffer
6. For LSP/formatting changes, open a file of the relevant type and run `:LspInfo` / `:ConformInfo`

## External Dependencies

These are expected on the system (not managed by this repo):

- Neovim 0.10+ (LazyVim requirement)
- `stylua` (for Lua formatting)
- `ruby-lsp` gem (for Ruby LSP)
- `standardrb` and `htmlbeautifier` gems (or installed via Mason)
- `git` (for lazy.nvim bootstrap and gitsigns)
