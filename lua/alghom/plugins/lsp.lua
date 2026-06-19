-- lua/alghom/plugins/lsp.lua
-- Language Server Protocol (LSP) setup: code intelligence for all languages.
-- LSP gives you: go-to-definition, hover docs, rename, find references, diagnostics.
--
-- HOW IT WORKS:
--   mason.nvim          → installs language servers (like a package manager for LSPs)
--   mason-lspconfig     → bridges mason with nvim-lspconfig
--   nvim-lspconfig      → connects nvim to the installed language servers
--
-- TO ADD A NEW LANGUAGE SERVER:
--   1. Add its name to ensure_installed below (find names at https://mason-registry.dev)
--   2. Run :Mason inside nvim to see/manage installed servers
--   3. The server will be set up automatically — no extra config needed for most servers
--
-- TO ADD A CUSTOM SERVER CONFIG (e.g. special settings for lua_ls):
--   Add a named handler inside the handlers table:
--     lua_ls = function()
--         lspconfig.lua_ls.setup({ settings = { ... } })
--     end,
--
-- LSP KEYMAPS (applied to every buffer where an LSP attaches):
--   K        → hover documentation
--   gd       → go to definition
--   gD       → go to declaration
--   gi       → go to implementation
--   go       → go to type definition
--   gr       → list all references
--   gs       → signature help
--   gl       → show diagnostic in floating window
--   [d / ]d  → jump to previous/next diagnostic
--   <F2>     → rename symbol under cursor
--   <F3>     → format file
--   <F4>     → code action (quick fixes, imports, etc.)
--
-- NOTE: jdtls (Java) is excluded here — it's handled separately in ftplugin/java.lua

return {
    'neovim/nvim-lspconfig',
    'mfussenegger/nvim-dap',   -- Debug Adapter Protocol (used by Java debug)
    'mfussenegger/nvim-jdtls', -- Java LSP client (configured in ftplugin/java.lua)
    {
        'williamboman/mason.nvim',
        config = function()
            require('mason').setup()
        end,
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            'williamboman/mason.nvim',
            'neovim/nvim-lspconfig',
            'hrsh7th/cmp-nvim-lsp',  -- Needed to pass LSP capabilities to cmp
        },
        config = function()
            local lspconfig = require('lspconfig')
            -- Tell each LSP about nvim-cmp's extra completion capabilities
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- Attach keymaps whenever an LSP connects to a buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local opts = { buffer = args.buf }
                    vim.keymap.set('n', 'K',    vim.lsp.buf.hover,           opts)
                    vim.keymap.set('n', 'gd',   vim.lsp.buf.definition,      opts)
                    vim.keymap.set('n', 'gD',   vim.lsp.buf.declaration,     opts)
                    vim.keymap.set('n', 'gi',   vim.lsp.buf.implementation,  opts)
                    vim.keymap.set('n', 'go',   vim.lsp.buf.type_definition, opts)
                    vim.keymap.set('n', 'gr',   vim.lsp.buf.references,      opts)
                    vim.keymap.set('n', 'gs',   vim.lsp.buf.signature_help,  opts)
                    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename,          opts)
                    vim.keymap.set('n', '<F3>', vim.lsp.buf.format,          opts)
                    vim.keymap.set({'n','v'}, '<F4>', vim.lsp.buf.code_action, opts)
                    vim.keymap.set('n', 'gl',   vim.diagnostic.open_float,   opts)
                    vim.keymap.set('n', '[d',   vim.diagnostic.goto_prev,    opts)
                    vim.keymap.set('n', ']d',   vim.diagnostic.goto_next,    opts)
                end,
            })

            require('mason-lspconfig').setup({
                -- Servers to auto-install. Add more here as needed.
                ensure_installed = { 'jdtls', 'ts_ls', 'lua_ls', 'gopls' },
                automatic_installation = true,
                handlers = {
                    -- Default handler: set up every server with cmp capabilities
                    function(server_name)
                        if server_name ~= 'jdtls' then  -- jdtls is handled in ftplugin/java.lua
                            lspconfig[server_name].setup({ capabilities = capabilities })
                        end
                    end,
                    -- Add per-server overrides here if needed, e.g.:
                    -- lua_ls = function()
                    --     lspconfig.lua_ls.setup({ settings = { Lua = { ... } } })
                    -- end,
                },
            })
        end,
    },
}
