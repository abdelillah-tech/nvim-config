# My Neovim Config — Beginner's Guide

> **TL;DR** — If you forget everything, just open nvim and look at the dashboard.
> It shows all your keybindings. Press `<Space>gg` for git, `<Space>f` for files.

---

## Table of Contents

1. [How the config is organized](#1-how-the-config-is-organized)
2. [The plugin manager — lazy.nvim](#2-the-plugin-manager--lazynvim)
3. [File by file reference](#3-file-by-file-reference)
4. [All keybindings](#4-all-keybindings)
5. [Common tasks](#5-common-tasks)
6. [Beginner tips](#6-beginner-tips)

---

## 1. How the config is organized

```
~/.config/nvim/
│
├── init.lua                        ← Entry point (just loads lua/alghom/init.lua)
│
├── ftplugin/
│   └── java.lua                    ← Java-only config (runs when you open a .java file)
│
└── lua/
    └── alghom/                     ← Your personal namespace (your name)
        ├── init.lua                ← Wires everything together + bootstraps lazy.nvim
        ├── set.lua                 ← Editor settings (line numbers, tabs, undo...)
        ├── remap.lua               ← Global keymaps (not plugin-specific)
        └── plugins/                ← One file per plugin category
            ├── ui.lua              ← Colorscheme + dashboard
            ├── editor.lua          ← Oil (files), Undotree, Autopairs
            ├── telescope.lua       ← Fuzzy file/text finder
            ├── treesitter.lua      ← Syntax highlighting
            ← git.lua              ← Fugitive + Neogit + Diffview
            ├── lsp.lua             ← Mason + LSP servers + keymaps
            └── cmp.lua             ← Autocompletion + snippets
```

### The loading order

When you open nvim, this is what happens step by step:

```
init.lua
  └─→ lua/alghom/init.lua
        ├─→ set.lua      (settings first)
        ├─→ remap.lua    (keymaps second, leader key must exist before plugins)
        └─→ lazy.nvim    (plugin manager loads all files in lua/alghom/plugins/)
              ├─→ plugins/ui.lua
              ├─→ plugins/editor.lua
              ├─→ plugins/telescope.lua
              ├─→ plugins/treesitter.lua
              ├─→ plugins/git.lua
              ├─→ plugins/lsp.lua
              └─→ plugins/cmp.lua
```

---

## 2. The plugin manager — lazy.nvim

Your plugin manager is **lazy.nvim**. It replaces the older packer.nvim.

### Opening the plugin manager UI

Inside nvim, type:

```
:Lazy
```

This opens a window showing all your installed plugins. You can navigate it with:

| Key | Action |
|-----|--------|
| `I` | Install missing plugins |
| `U` | Update all plugins |
| `S` | Sync (install missing + update + clean unused) |
| `C` | Clean (remove plugins no longer in your config) |
| `L` | Show the changelog for a plugin |
| `q` | Close the window |

### How a plugin entry looks

Every plugin in `lua/alghom/plugins/*.lua` follows this pattern:

```lua
{
    'author/plugin-name',           -- The GitHub repo (required)
    dependencies = { 'other/dep' }, -- Other plugins this one needs
    event = "InsertEnter",          -- When to load it (optional — for performance)
    build = 'make install',         -- Command to run after installing (optional)
    config = function()
        -- Setup code goes here
        require('plugin-name').setup({})
        -- Keymaps go here too
        vim.keymap.set('n', '<leader>x', ...)
    end,
}
```

### Installing a new plugin

1. Find a plugin on GitHub (e.g. `folke/todo-comments.nvim`)
2. Open the relevant file in `lua/alghom/plugins/` (or create a new one)
3. Add a plugin entry:

```lua
{
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('todo-comments').setup({})
    end,
},
```

4. Save the file and run `:Lazy sync` inside nvim
5. The plugin installs automatically

### Removing a plugin

1. Delete or comment out the plugin entry in the relevant file
2. Run `:Lazy sync` — it will uninstall it

### Updating all plugins

Run `:Lazy sync` or press `U` inside the `:Lazy` window.

---

## 3. File by file reference

### `lua/alghom/set.lua` — Editor settings

Change things like tab size, line numbers, wrap, etc.

```lua
vim.opt.tabstop = 4      -- Change to 2 for JavaScript/TypeScript style
vim.opt.shiftwidth = 4   -- Same as tabstop
vim.opt.relativenumber = true  -- Set to false if you don't want relative numbers
vim.opt.wrap = false     -- Set to true if you want lines to wrap
```

### `lua/alghom/remap.lua` — Global keymaps

Add keymaps that don't belong to any specific plugin.

```lua
-- Format: vim.keymap.set(mode, keys, action, options)
-- mode: "n" = normal, "v" = visual, "i" = insert, "x" = visual-block

-- Example — save with Ctrl+S:
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save file" })
```

### `lua/alghom/plugins/lsp.lua` — Language servers

**To add a new language server:**

1. Find the server name at https://mason-registry.dev/registry/list
2. Add it to `ensure_installed`:

```lua
ensure_installed = { 'jdtls', 'ts_ls', 'lua_ls', 'gopls', 'pyright' },
--                                                           ^^^^^^^^ add here
```

3. Restart nvim — Mason installs it automatically

**To add custom settings for a specific server:**

Add a named handler inside `handlers`:

```lua
handlers = {
    -- Default (applies to all servers not listed below)
    function(server_name)
        lspconfig[server_name].setup({ capabilities = capabilities })
    end,
    -- Custom config for lua_ls
    lua_ls = function()
        lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
                Lua = { diagnostics = { globals = { 'vim' } } }
            }
        })
    end,
}
```

### `lua/alghom/plugins/cmp.lua` — Autocompletion

**To add a new completion source:**

1. Add the plugin to `dependencies`
2. Add the source to the `sources` list:

```lua
sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'your_new_source' },  -- add here
}),
```

### `ftplugin/java.lua` — Java-specific config

This file runs automatically whenever you open a `.java` file.

**Key things you might want to change:**

```lua
-- The Java binary used to RUN jdtls (must be Java 17+)
local java_bin_path = vim.fn.expand('~/.sdkman/candidates/java/17.0.4-oracle/bin/java')
-- ↑ Change this path to your actual JDK location

-- Platform config — change if you're not on Mac ARM
path.platform_config = jdtls_install .. '/config_mac_arm'
-- Options: config_mac, config_mac_arm, config_linux, config_win

-- Runtimes — tells jdtls which JDKs exist for your projects
runtimes = {
    { name = 'JavaSE-17', path = vim.fn.expand('~/.sdkman/candidates/java/17.0.4-oracle') },
    { name = 'JavaSE-21', path = vim.fn.expand('~/.sdkman/candidates/java/21.0.2-tem') },
    -- Add more here: { name = 'JavaSE-11', path = '...' }
}
```

---

## 4. All keybindings

> `<Space>` is your leader key. `<leader>x` means press Space then x.

### Navigation & files

| Key | Action | Plugin |
|-----|--------|--------|
| `<Space>f` | Find file by name | Telescope |
| `<C-p>` | Find file (git-tracked only) | Telescope |
| `<Space>s` | Search text inside files | Telescope |
| `-` | Open file explorer (current dir) | Oil |
| `<Space>u` | Toggle undo history tree | Undotree |

> **Inside Oil (file explorer):** press Enter to open, `-` to go up, `_` to open current dir, `q` to quit.
> **Inside Telescope:** `<C-n>`/`<C-p>` to move, Enter to open, `<C-v>` to open in split.

### Git

| Key | Action | Plugin |
|-----|--------|--------|
| `<Space>gs` | Quick git status | Fugitive |
| `<Space>gg` | Full git panel (staged/unstaged/stash) | Neogit |
| `<Space>gd` | Side-by-side diff of all changes | Diffview |
| `<Space>gh` | Git history of current file | Diffview |

> **Inside Neogit:** press `?` to see all available actions (stage, commit, push, pull, stash...).
> **Close Fugitive/Neogit/Diffview:** press `q`.

### LSP (code intelligence)

These work in any file where an LSP is active.

| Key | Action |
|-----|--------|
| `K` | Show hover documentation |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `go` | Go to type definition |
| `gr` | List all references |
| `gs` | Show signature help |
| `gl` | Show diagnostic (error/warning) details |
| `[d` | Jump to previous diagnostic |
| `]d` | Jump to next diagnostic |
| `<F2>` | Rename symbol under cursor |
| `<F3>` | Format file |
| `<F4>` | Code action (fix imports, quick fixes...) |

### Autocompletion (while popup is open)

| Key | Action |
|-----|--------|
| `<Tab>` | Select next item / jump through snippet |
| `<S-Tab>` | Select previous item |
| `<CR>` | Confirm selection |
| `<C-Space>` | Manually trigger completion |
| `<C-e>` | Close the completion menu |
| `<C-b>` / `<C-f>` | Scroll documentation up/down |

### Java only (in `.java` files)

| Key | Action |
|-----|--------|
| `<Space>df` | Run all tests in current class |
| `<Space>dn` | Run the test under the cursor |
| `<A-o>` | Organize imports |
| `crv` | Extract variable (also works in visual mode) |
| `crc` | Extract constant (also works in visual mode) |
| `crm` | Extract method (visual mode — select code first) |

### Editing

| Key | Mode | Action |
|-----|------|--------|
| `J` | Visual | Move selected lines down |
| `K` | Visual | Move selected lines up |
| `<Space>p` | Visual | Paste without overwriting clipboard |

### Plugin manager

| Command | Action |
|---------|--------|
| `:Lazy` | Open plugin manager UI |
| `:Lazy sync` | Install + update + clean plugins |
| `:Lazy update` | Update all plugins |
| `:Mason` | Open LSP/tool installer UI |

---

## 5. Common tasks

### Add a plugin

```lua
-- In the relevant file in lua/alghom/plugins/
-- (or create lua/alghom/plugins/myplugins.lua)
{
    'author/plugin-name',
    config = function()
        require('plugin-name').setup({})
    end,
},
```

Then run `:Lazy sync`.

### Add a language server

In `lua/alghom/plugins/lsp.lua`, add to `ensure_installed`:
```lua
ensure_installed = { 'jdtls', 'ts_ls', 'lua_ls', 'gopls', 'your_server' },
```

Restart nvim. Or run `:Mason` to install manually with a UI.

### Add a keymap

```lua
-- In remap.lua for global keymaps, or inside a plugin's config function
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save" })
--             mode  keys         action     description (shows in :map)
```

### Change tab size (e.g. to 2 spaces)

In `lua/alghom/set.lua`:
```lua
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
```

### Update all plugins

```
:Lazy sync
```

### Check what's installed / fix broken plugins

```
:Lazy        ← shows all plugins and their status
:Mason       ← shows all LSP servers and tools
:checkhealth ← diagnoses common issues with your setup
```

### Reload config without restarting

```
:source %              ← reload the current file
:source $MYVIMRC       ← reload init.lua
```

> Note: Some changes (especially plugin configs) require a full restart of nvim.

---

## 6. Beginner tips

### Modes

Neovim has different modes. You'll use these most:

| Mode | How to enter | What it's for |
|------|-------------|---------------|
| Normal | `<Esc>` | Navigation, commands |
| Insert | `i` (before cursor) or `a` (after) | Typing text |
| Visual | `v` | Selecting text |
| Visual line | `V` | Selecting whole lines |
| Command | `:` | Running commands like `:w`, `:q` |

### Essential normal mode commands

| Key | Action |
|-----|--------|
| `i` | Enter insert mode |
| `<Esc>` | Go back to normal mode |
| `:w` | Save |
| `:q` | Quit |
| `:wq` | Save and quit |
| `:q!` | Quit without saving |
| `u` | Undo |
| `<C-r>` | Redo |
| `gg` | Go to top of file |
| `G` | Go to bottom of file |
| `dd` | Delete (cut) current line |
| `yy` | Copy current line |
| `p` | Paste below |
| `/text` | Search for "text" (press `n` for next match) |
| `*` | Search for word under cursor |

### If something breaks

1. Run `:checkhealth` — it diagnoses common problems
2. Run `:Lazy` — check if plugins are installed correctly
3. Run `:messages` — see recent error messages
4. Check the file that changed and look for typos

### If nvim won't start at all

Open the terminal and run:
```bash
nvim --headless "+Lazy! sync" +qa
```
This syncs plugins without opening the UI.

### Where plugins are stored on disk

```
~/.local/share/nvim/lazy/     ← all plugin files live here
~/.local/state/nvim/lazy/     ← lazy.nvim lock file (lazy-lock.json)
~/.vim/undodir/               ← persistent undo history
```

### The lazy-lock.json file

When you run `:Lazy sync`, a file called `lazy-lock.json` is created/updated at:
```
~/.config/nvim/lazy-lock.json
```
This locks every plugin to an exact commit, so your setup is reproducible.
If a plugin update breaks something, you can revert with `:Lazy restore`.

---

*Config lives in: `~/.config/nvim/`*
*Plugin manager docs: https://lazy.folke.io*
*Neovim docs: https://neovim.io/doc/ or type `:help` inside nvim*
