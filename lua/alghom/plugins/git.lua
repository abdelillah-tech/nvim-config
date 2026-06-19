-- lua/alghom/plugins/git.lua
-- Git integration: status, staging, commits, diffs, and history.
--
-- Two git plugins work together here:
--   vim-fugitive  → quick git commands via :Git (lightweight, always available)
--   neogit        → full IDE-style git panel (staged/unstaged/stash like IntelliJ)
--
-- KEYMAPS:
--   <Space>gs  → open Fugitive git status (quick view, press "q" to close)
--   <Space>gg  → open Neogit panel (full panel, press "?" inside for help)
--   <Space>gd  → open diff view (side-by-side diff of all changed files)
--   <Space>gh  → show git history of current file
--
-- Inside Neogit, press "?" to see all available actions (stage, commit, push, stash...).
-- Inside Diffview, press "q" to close.

return {
    -- ─── Fugitive ─────────────────────────────────────────────────────────────
    -- Lightweight git integration. Useful for quick :Git blame, :Git log, etc.
    {
        'tpope/vim-fugitive',
        config = function()
            vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
        end,
    },

    -- ─── Neogit + Diffview ────────────────────────────────────────────────────
    -- Full git panel similar to IntelliJ's Git tool window.
    -- diffview.nvim is the diff viewer that Neogit uses when you press "d" on a file.
    {
        'NeogitOrg/neogit',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'sindrets/diffview.nvim',
        },
        config = function()
            local neogit = require('neogit')
            neogit.setup({ integrations = { diffview = true } })
            vim.keymap.set('n', '<leader>gg', neogit.open,                    { desc = 'Neogit' })
            vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>',        { desc = 'Diff view' })
            vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', { desc = 'File history' })
        end,
    },
}
