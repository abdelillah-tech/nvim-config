-- lua/alghom/plugins/neotree.lua
-- File tree sidebar — ideal for Java multi-module projects.
-- Toggle with <Space>e. Git status icons shown next to files.

return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        cmd = "Neotree",
        keys = {
            { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle file tree" },
            { "<leader>o", "<cmd>Neotree focus<CR>",  desc = "Focus file tree" },
        },
        opts = {
            close_if_last_window = true,
            window = {
                position = "left",
                width = 35,
            },
            filesystem = {
                follow_current_file = {
                    enabled = true,       -- highlight the current file in the tree
                    leave_dirs_open = true,
                },
                use_libuv_file_watcher = true,  -- auto-refresh on external file changes
                filtered_items = {
                    hide_dotfiles = false,
                    hide_gitignored = false,
                },
            },
            git_status = {
                window = { position = "float" },
            },
        },
    },
}
