-- lua/alghom/plugins/cmp.lua
-- Autocompletion engine and snippet support.
--
-- HOW IT WORKS:
--   nvim-cmp     → the completion engine (shows the popup menu)
--   LuaSnip      → snippet engine (expands code templates)
--   cmp sources  → where completions come from (LSP, open buffers, file paths, snippets)
--   lspkind      → adds icons to completion items (function, variable, class...)
--
-- COMPLETION KEYMAPS (active while the popup is open):
--   <Tab>      → select next item / expand or jump through snippet
--   <S-Tab>    → select previous item / jump backwards in snippet
--   <CR>       → confirm selected completion
--   <C-Space>  → manually trigger completion
--   <C-e>      → close the completion menu
--   <C-b>/<C-f> → scroll docs up/down
--
-- TO ADD A NEW SOURCE:
--   1. Add the source plugin to dependencies
--   2. Add { name = 'source_name' } to the sources list
--   Available sources: https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources

return {
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',                 -- Completions from the language server
            'hrsh7th/cmp-buffer',                   -- Completions from words in open buffers
            'hrsh7th/cmp-path',                     -- Completions for file system paths
            'hrsh7th/cmp-nvim-lsp-signature-help',  -- Shows function signature while typing args
            'onsails/lspkind.nvim',                 -- Icons in the completion menu
            'saadparwaiz1/cmp_luasnip',             -- Snippet completions via LuaSnip
            {
                'L3MON4D3/LuaSnip',
                dependencies = 'rafamadriz/friendly-snippets',  -- A large collection of pre-built snippets
                -- Compile the snippet regex engine for better performance (skipped on Windows)
                build = (vim.loop.os_uname().sysname ~= "Windows") and 'make install_jsregexp' or nil,
                config = function()
                    -- Load VS Code-style snippets from friendly-snippets
                    require("luasnip.loaders.from_vscode").lazy_load()
                end,
            },
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            local lspkind = require('lspkind')

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>']     = cmp.mapping.scroll_docs(-4),
                    ['<C-f>']     = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>']     = cmp.mapping.abort(),
                    ['<CR>']      = cmp.mapping.confirm({ select = true }),
                    -- Tab: move through completion list OR jump through snippet placeholders
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                -- Sources are checked in order — LSP results come first
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lsp_signature_help' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                    { name = 'path' },
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = 'symbol_text',  -- Show icon + text label
                        maxwidth = 50,         -- Truncate long completion labels
                    }),
                },
            })
        end,
    },
}
