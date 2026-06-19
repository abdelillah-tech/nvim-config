-- lua/alghom/set.lua
-- Core Neovim editor settings. These apply globally regardless of plugins.
-- Change any value here and restart nvim (or :source %) to apply.

-- vim.opt.guicursor = ""  -- Uncomment to force block cursor in all modes

vim.opt.nu = true              -- Show absolute line number on current line
vim.opt.relativenumber = true  -- Show relative line numbers (useful for jump commands like 5j, 10k)

-- Indentation: 4-space tabs (good for Java)
-- To switch to 2-space (e.g. for JS/TS), change all three to 2.
vim.opt.tabstop = 4       -- A tab character counts as 4 spaces visually
vim.opt.softtabstop = 4   -- Pressing Tab/Backspace moves 4 spaces
vim.opt.shiftwidth = 4    -- >> and << indent/dedent by 4 spaces
vim.opt.expandtab = true  -- Insert spaces instead of actual tab characters

vim.opt.smartindent = true  -- Auto-indent new lines based on context

vim.opt.wrap = false  -- Don't wrap long lines (scroll horizontally instead)

-- Disable swap/backup files — undo history handles recovery instead
vim.opt.swapfile = false
vim.opt.backup = false

-- Persistent undo: changes survive closing nvim
-- The undo history is stored in ~/.vim/undodir
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
