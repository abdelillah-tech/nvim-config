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
        build = ':TSUpdate',  -- Updates all parsers when the plugin updates
        config = function()
            require('nvim-treesitter.configs').setup({
                -- Parsers to install automatically on first launch
                ensure_installed = {
                    "html", "css", "javascript", "typescript",
                    "java", "c", "lua", "vim", "vimdoc", "query",
                },
                sync_install = false,  -- Install parsers in the background
                auto_install = true,   -- Auto-install parser when you open an unsupported file
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            })
        end,
    },

    -- Treesitter playground: inspect the syntax tree of the current file.
    -- Use :TSPlaygroundToggle to open it. Useful for debugging highlight issues.
    'nvim-treesitter/playground',
}
