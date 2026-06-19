-- lua/alghom/init.lua
-- This is the main entry point for your personal config (the "alghom" namespace).
-- It loads your settings, keymaps, and then bootstraps the plugin manager (lazy.nvim).
-- Order matters: set + remap must come before lazy so your leader key is set first.

require("alghom.set")    -- Editor settings (line numbers, tabs, undo, etc.)
require("alghom.remap")  -- Global keymaps (non-plugin shortcuts)

-- ─── Bootstrap lazy.nvim ─────────────────────────────────────────────────────
-- lazy.nvim is the plugin manager. This block auto-installs it if it's missing.
-- You don't need to touch this — it just works.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- This tells lazy.nvim to load all plugin specs from lua/alghom/plugins/*.lua
-- Each file in that folder returns a table of plugins.
-- To add a plugin: create or edit a file in lua/alghom/plugins/.
-- To remove a plugin: delete or comment out its entry and run :Lazy sync.
require("lazy").setup("alghom.plugins")

