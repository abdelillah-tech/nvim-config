-- lua/alghom/plugins/editor.lua
-- General editing plugins: file navigation, undo history, auto-closing brackets.
--
-- To add a new plugin: add a new table entry following the same pattern.
-- To change a keymap: find the vim.keymap.set call and change the second argument (the keys).

return {
    -- ─── Oil ─────────────────────────────────────────────────────────────────
    -- File explorer that works like a buffer (edit filenames, delete, rename).
    -- Press "-" to open the parent directory of the current file.
    -- Press "-" again to go up another level. Press Enter to open a file/folder.
    {
        'stevearc/oil.nvim',
        config = function()
            require('oil').setup({})
            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
        end,
    },

    -- ─── Undotree ─────────────────────────────────────────────────────────────
    -- Visual undo history: see every change as a tree, not a linear list.
    -- Useful when you undo too far and want to "redo" to a specific point.
    -- Press <Space>u to toggle the panel. Navigate with J/K, press Enter to jump.
    {
        'mbbill/undotree',
        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end,
    },

    -- ─── Autopairs ────────────────────────────────────────────────────────────
    -- Automatically closes brackets, quotes, parentheses as you type.
    -- No config needed — works out of the box.
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",  -- Only loads when you enter insert mode (faster startup)
        config = true,
    },
}
