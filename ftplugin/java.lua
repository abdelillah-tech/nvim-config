-- ftplugin/java.lua
-- Java-specific LSP configuration using nvim-jdtls (Eclipse JDT Language Server).
-- This file runs automatically every time you open a .java file.
-- It is separate from lsp.lua because jdtls requires special startup logic.
--
-- PREREQUISITES (installed via Mason — run :Mason to check):
--   - jdtls              (the Java language server)
--   - java-test          (enables running tests from nvim)
--   - java-debug-adapter (enables debugging)
--
-- TO CHANGE THE JAVA VERSION USED TO RUN JDTLS:
--   Edit the java_bin_path variable below (line ~52).
--   jdtls requires Java 17+. The runtimes table below tells it which JDKs
--   are available for your actual projects (can differ from the jdtls JDK).
--
-- TO ADD A NEW JDK RUNTIME (so jdtls knows about it):
--   Add an entry to the runtimes list in settings.java.configuration.runtimes:
--     { name = 'JavaSE-21', path = vim.fn.expand('~/.sdkman/candidates/java/21.0.2-tem') }
--   The name must match a known Java SE version string (JavaSE-11, JavaSE-17, JavaSE-21...).
--
-- TO CHANGE THE PLATFORM (not on Mac ARM):
--   Edit path.platform_config. Options: config_mac, config_mac_arm, config_linux, config_win
--
-- JAVA-SPECIFIC KEYMAPS (only active in .java files):
--   <Space>df  → run all tests in the current class
--   <Space>dn  → run the test method under the cursor
--   <A-o>      → organize imports
--   crv        → extract variable (works in visual mode too)
--   crc        → extract constant (works in visual mode too)
--   crm        → extract method (visual mode only — select code first)

local jdtls = require("jdtls")
local mason_registry = require("mason-registry")
local jdtls_install = mason_registry
.get_package('jdtls')
:get_install_path()
local path = {}

path.data_dir = vim.fn.stdpath('cache') .. '/nvim-jdtls'
path.java_agent = jdtls_install .. '/lombok.jar'
path.launcher_jar = vim.fn.glob(jdtls_install .. '/plugins/org.eclipse.equinox.launcher_*.jar')
path.jdk_homes = vim.fn.expand('~/.sdkman/candidates/java')
path.jdk_bin = path.jdk_homes .. '/current/bin/java'
path.platform_config = jdtls_install .. '/config_mac_arm'

path.bundles = {}

---
-- Include java-test bundle if present
---

local java_test_path = mason_registry
.get_package('java-test')
:get_install_path()


local java_test_bundle = vim.split(
vim.fn.glob(java_test_path .. '/extension/server/*.jar'),
'\n'
)

if java_test_bundle ~= nil and java_test_bundle[1] ~= '' then
    vim.list_extend(path.bundles, java_test_bundle)
end

---
-- Include java-debug-adapter bundle if present
---
local java_debug_path = mason_registry
.get_package('java-debug-adapter')
:get_install_path()

local java_debug_bundle = vim.split(
vim.fn.glob(java_debug_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar'),
'\n'
)

if java_debug_bundle[1] ~= '' then
    vim.list_extend(path.bundles, java_debug_bundle)
end

local data_dir = path.data_dir .. '/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local java_bin_path = vim.fn.expand('~/.sdkman/candidates/java/17.0.4-oracle/bin/java')
local config = {
    cmd = {
        java_bin_path,
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xms4g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-javaagent:' .. path.java_agent,
        '-jar', path.launcher_jar,
        '-configuration', path.platform_config,
        '-data', data_dir,
    },
    root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
    flags = {
        allow_incremental_sync = true,
    },
    settings = {
        java = {
            eclipse = {
                downloadSources = true,
            },
            configuration = {
                updateBuildConfiguration = 'interactive',
                runtimes = {
                    {
                        name = 'JavaSE-17',
                        path = vim.fn.expand('~/.sdkman/candidates/java/17.0.4-oracle'),
                    },
                    {
                        name = 'JavaSE-21',
                        path = vim.fn.expand('~/.sdkman/candidates/java/21.0.2-zulu'),
                    }
                },
            },
            maven = {
                downloadSources = true,
            },
            implementationsCodeLens = {
                enabled = true,
            },
            referencesCodeLens = {
                enabled = true,
            },
            references = {
                includeDecompiledSources = true,
            },
        },
        signatureHelp = {
            enabled = true,
        },
        completion = {
            favoriteStaticMembers = {
                'org.hamcrest.MatcherAssert.assertThat',
                'org.hamcrest.Matchers.*',
                'org.hamcrest.CoreMatchers.*',
                'org.junit.jupiter.api.Assertions.*',
                'java.util.Objects.requireNonNull',
                'java.util.Objects.requireNonNullElse',
                'org.mockito.Mockito.*',
            },
            importOrder = {
                "java",
                "javax",
                "com",
                "org"
            },
        },
        contentProvider = {
            preferred = 'fernflower',
        },
        extendedClientCapabilities = jdtls.extendedClientCapabilities,
        sources = {
            organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
            }
        },
        codeGeneration = {
            toString = {
                template =
                '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
            },
            useBlocks = true,
        },
    },
    on_attach = function (_, bufnr)
        require('jdtls.dap').setup_dap_main_class_configs()

        jdtls.setup_dap({ hotcodereplace = 'auto' })

        local opts = {buffer = bufnr}

        vim.keymap.set('n', '<leader>df', "<cmd>lua require('jdtls').test_class()<cr>", opts)
        vim.keymap.set('n', '<leader>dn', "<cmd>lua require('jdtls').test_nearest_method()<cr>", opts)

        pcall(vim.lsp.codelens.refresh)

        vim.keymap.set('n', '<A-o>', "<cmd>lua require('jdtls').organize_imports()<cr>", opts)
        vim.keymap.set('n', 'crv', "<cmd>lua require('jdtls').extract_variable()<cr>", opts)
        vim.keymap.set('x', 'crv', "<esc><cmd>lua require('jdtls').extract_variable(true)<cr>", opts)
        vim.keymap.set('n', 'crc', "<cmd>lua require('jdtls').extract_constant()<cr>", opts)
        vim.keymap.set('x', 'crc', "<esc><cmd>lua require('jdtls').extract_constant(true)<cr>", opts)
        vim.keymap.set('x', 'crm', "<esc><Cmd>lua require('jdtls').extract_method(true)<cr>", opts)

    end,
    capabilities = vim.tbl_deep_extend(
      'force',
      vim.lsp.protocol.make_client_capabilities(),
      require('cmp_nvim_lsp').default_capabilities() or {}
    ),
    init_options = {
        bundles = path.bundles,
    }
}

jdtls.start_or_attach(config)
