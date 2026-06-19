-- lua/alghom/remap.lua
-- Global keymaps that don't depend on any plugin.
-- Plugin-specific keymaps live inside each plugin's config in lua/alghom/plugins/.
--
-- HOW TO ADD A KEYMAP:
--   vim.keymap.set(mode, keys, action, opts)
--   mode: "n" = normal, "v" = visual, "i" = insert, "x" = visual-block
--   Example: vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })

-- Set Space as the leader key.
-- The leader key is used as a prefix for custom shortcuts (e.g. <leader>f = Space+f).
-- This MUST be set before lazy.nvim loads plugins.
vim.g.mapleader = " "

-- Move selected lines up/down in visual mode with J/K
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")  -- Move selection down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")  -- Move selection up

-- Paste over selection without losing what's in the clipboard.
-- Without this, pasting over selected text replaces your clipboard with the deleted text.
vim.keymap.set("x", "<leader>p", "\"_dP")
