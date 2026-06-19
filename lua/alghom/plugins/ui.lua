-- lua/alghom/plugins/ui.lua
-- Visual/UI plugins: colorscheme and the startup dashboard.
--
-- To change the colorscheme:
--   1. Add/replace the colorscheme plugin below (search GitHub for "neovim colorscheme")
--   2. Change the vim.cmd.colorscheme('rose-pine') call to your new theme name
--
-- To edit the dashboard buttons: find dashboard.section.buttons.val and add/remove entries.
--   Format: dashboard.button("shortcut", "icon  Label", ":Command<CR>")
--
-- To edit the cheatsheet text: find the cheatsheet.val table and edit the strings.

return {
    -- ─── Colorscheme ─────────────────────────────────────────────────────────
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        priority = 1000,  -- Load before other plugins so colors apply first
        config = function()
            vim.cmd.colorscheme('rose-pine')
        end,
    },

    -- ─── Dashboard (startup screen) ───────────────────────────────────────────
    {
        'goolord/alpha-nvim',
        config = function()
            local alpha = require('alpha')
            local dashboard = require('alpha.themes.dashboard')

            -- ASCII art header shown at the top
            dashboard.section.header.val = {
                "                                                     ",
                "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
                "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
                "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
                "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
                "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
                "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
                "                                                     ",
            }

            -- Clickable shortcut buttons in the center of the dashboard
            dashboard.section.buttons.val = {
                dashboard.button("<Space> f", "  Find File",     ":Telescope find_files<CR>"),
                dashboard.button("<C-p>",     "  Git Files",     ":Telescope git_files<CR>"),
                dashboard.button("<Space> s", "  Live Grep",     ":Telescope live_grep<CR>"),
                dashboard.button("-",         "  File Explorer", ":Oil<CR>"),
                dashboard.button("<Space> gs","  Git Status",    ":Git<CR>"),
                dashboard.button("<Space> gg","  Neogit Panel",  ":Neogit<CR>"),
                dashboard.button("<Space> u", "  Undo Tree",     ":UndotreeToggle<CR>"),
                dashboard.button("q",         "  Quit",          ":qa<CR>"),
            }

            -- Static cheatsheet shown below the buttons as a reminder
            local cheatsheet = {
                type = "text",
                val = {
                    "─────────────────── LSP ─────────────────────────────────────",
                    "  K        Hover docs         gd   Go to Definition           ",
                    "  gD       Go to Declaration  gi   Go to Implementation       ",
                    "  gr       References         go   Go to Type Def             ",
                    "  gs       Signature help     gl   Show Diagnostic            ",
                    "  [d / ]d  Prev/Next Diag    <F2>  Rename                    ",
                    "  <F3>     Format            <F4>  Code Action                ",
                    "                                                               ",
                    "─────────────────── Git ──────────────────────────────────────",
                    "  <Space>gg  Neogit panel      <Space>gs  Git status          ",
                    "  <Space>gd  Diff view         <Space>gh  File history        ",
                    "                                                               ",
                    "─────────────────── Java ─────────────────────────────────────",
                    "  <Space>df  Test class        <Space>dn  Test method         ",
                    "  <A-o>      Organize imports                                  ",
                    "  crv        Extract variable  crc        Extract constant     ",
                    "  crm        Extract method (visual)                           ",
                    "                                                               ",
                    "─────────────────── Editing ──────────────────────────────────",
                    "  J / K (visual)    Move line down/up                         ",
                    "  <Space>p (visual) Paste without yanking                     ",
                },
                opts = { hl = "Comment", position = "center" },
            }

            dashboard.section.header.opts.hl = "Keyword"

            alpha.setup({
                layout = {
                    { type = "padding", val = 1 },
                    dashboard.section.header,
                    { type = "padding", val = 1 },
                    dashboard.section.buttons,
                    { type = "padding", val = 1 },
                    cheatsheet,
                }
            })
        end,
    },
}
