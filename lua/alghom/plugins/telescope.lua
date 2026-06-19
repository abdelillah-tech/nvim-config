-- lua/alghom/plugins/telescope.lua
-- Fuzzy finder for files, text, git, and more.
--
-- KEYMAPS (set below):
--   <Space>f  → search files by name
--   <C-p>     → search files tracked by git
--   <Space>s  → search text inside files (live grep)
--
-- Inside a Telescope window:
--   <C-n>/<C-p>  move up/down the list
--   <CR>         open selected file
--   <C-x>        open in horizontal split
--   <C-v>        open in vertical split
--   <Esc>        close
--
-- To add more pickers: https://github.com/nvim-telescope/telescope.nvim#pickers

return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.2.2',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>f', builtin.find_files, {})
            vim.keymap.set('n', '<C-p>',     builtin.git_files,  {})
            vim.keymap.set('n', '<leader>s', builtin.live_grep,  {})
        end,
    },
}
