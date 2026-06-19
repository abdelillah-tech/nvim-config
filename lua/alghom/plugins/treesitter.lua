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
        lazy = false,  -- This plugin does not support lazy-loading
        build = ':TSUpdate',
        -- No setup needed: highlighting is automatic in the new nvim-treesitter rewrite.
        -- Install parsers with :TSInstall <language> or :TSInstall all
    },

    -- Note: :InspectTree is now built into nvim-treesitter (replaces the old playground plugin)
}
