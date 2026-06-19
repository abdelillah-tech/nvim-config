-- lua/alghom/plugins/treesitter.lua
-- Syntax highlighting and code understanding via tree-sitter parsers.
-- Treesitter gives much more accurate highlighting than regex-based approaches.
--
-- To add a new language: add its name to the ensure_installed list below.
-- Full list of supported languages: https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
-- You can also install manually inside nvim with: :TSInstall <language>

return {
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'master',  -- master branch supports Neovim 0.11; main requires 0.12+ nightly
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    "html", "css", "javascript", "typescript",
                    "java", "c", "lua", "vim", "vimdoc", "query",
                },
                sync_install = false,
                auto_install = true,
                highlight = { enable = true },
            })
        end,
    },

    -- Note: :InspectTree is built into Neovim 0.11+
}
