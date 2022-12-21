-- Setup lspconfig.
-- :h lspconfig-all
local default_capabilities = require('cmp_nvim_lsp').default_capabilities

local on_attach = require('user.lsp').on_attach

local lsp_servers = {
    -- clangd = {},
    tsserver = {},
    pyright = {},
    texlab = {},
    dartls = {},
}

for server, _ in pairs(lsp_servers) do
    require('lspconfig')[server].setup {
        capabilities = default_capabilities(),
        on_attach = on_attach
    }
end

require'lspconfig'.clangd.setup {
    capabilities = default_capabilities({
        snippetSupport = false,
    }
    ),
    on_attach = on_attach
}

require'lspconfig'.sumneko_lua.setup {
    on_attach = on_attach,
    capabilities = default_capabilities(),
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                -- globals = {'vim'},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                -- library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}

-- lsp from aur didn't work :(
require'lspconfig'.omnisharp.setup {
    capabilities = default_capabilities(),
    on_attach = on_attach,
    cmd = { "/home/connorcc/tmp/run", "-lsp" },

    -- Enables support for reading code style, naming convention and analyzer
    -- settings from .editorconfig.
    enable_editorconfig_support = true,

    -- If true, MSBuild project system will only load projects for files that
    -- were opened in the editor. This setting is useful for big C# codebases
    -- and allows for faster initialization of code navigation features only
    -- for projects that are relevant to code that is being edited. With this
    -- setting enabled OmniSharp may load fewer projects and may thus display
    -- incomplete reference lists for symbols.
    enable_ms_build_load_projects_on_demand = false,

    -- Enables support for roslyn analyzers, code fixes and rulesets.
    enable_roslyn_analyzers = false,

    -- Specifies whether 'using' directives should be grouped and sorted during
    -- document formatting.
    organize_imports_on_format = false,

    -- Enables support for showing unimported types and unimported extension
    -- methods in completion lists. When committed, the appropriate using
    -- directive will be added at the top of the current file. This option can
    -- have a negative impact on initial completion responsiveness,
    -- particularly for the first few completion sessions after opening a
    -- solution.
    enable_import_completion = false,

    -- Specifies whether to include preview versions of the .NET SDK when
    -- determining which version to use for project loading.
    sdk_include_prereleases = true,

    -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
    -- true
    analyze_open_documents_only = false,

    -- Does this do anything???
    -- Does setting it in .omnisharp/omnisharp.json do anything??
    -- omnisharp = {
    --     useModernNet = false,
    --     monoPath = "/usr/bin/mono"
    -- }
}
