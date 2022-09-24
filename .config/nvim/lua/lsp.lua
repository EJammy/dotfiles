-- Mappings.
-- See `:help vim.lsp.*` for documentation on any of the below functions
vim.api.nvim_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', {}) vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {})
vim.api.nvim_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {})
vim.api.nvim_set_keymap('n', 'gh', '<cmd>lua vim.lsp.buf.implementation()<CR>', {})
vim.api.nvim_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', {})

vim.api.nvim_set_keymap('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', {})
-- vim.api.nvim_set_keymap('i', '<C-space>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', {})

vim.api.nvim_set_keymap('n', '<space>la', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', {})
vim.api.nvim_set_keymap('n', '<space>lr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', {})
vim.api.nvim_set_keymap('n', '<space>ll', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', {})
vim.api.nvim_set_keymap('n', '<space>lD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', {})
vim.api.nvim_set_keymap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>', {})
-- vim.api.nvim_set_keymap('n', '<leader>l<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>', {})
vim.api.nvim_set_keymap('n', '<space>lc', '<cmd>lua vim.lsp.buf.code_action()<CR>', {})
vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', {})
vim.api.nvim_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', {})


vim.api.nvim_set_keymap('n', '<space>l<space>', '<cmd>lua vim.diagnostic.open_float()<CR>', {})


-- setup luasnip
vim.cmd([[
" press <Tab> to expand or jump in a snippet. These can also be mapped separately
" via <Plug>luasnip-expand-snippet and <Plug>luasnip-jump-next.
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
" -1 for jumping backwards.
inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>

snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>

" For changing choices in choiceNodes (not strictly necessary for a basic setup).
imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
]])

-- Setup nvim-cmp. (copied from doc)
local cmp = require'cmp'

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},

---Mapping preset insert-mode configuration.
-- mapping.preset.insert = function(override)
--   return merge_keymaps(override or {}, {
--     ['<Down>'] = {
--       i = mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Select }),
--     },
--     ['<Up>'] = {
--       i = mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Select }),
--     },
--     ['<C-n>'] = {
--       i = mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Insert }),
--     },
--     ['<C-p>'] = {
--       i = mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert }),
--     },
--     ['<C-y>'] = {
--       i = mapping.confirm({ select = false }),
--     },
--     ['<C-e>'] = {
--       i = mapping.abort(),
--     },
--   })
-- end
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		["<Tab>"] = cmp.mapping(function(fallback)
			local luasnip = require("luasnip")
			-- local has_words_before = function()
			--     local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			--     return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			-- end
			if cmp.visible() then
				cmp.select_next_item()
			-- let luasnip handle the rest with fallback
			-- elseif luasnip.expand_or_jumpable() then
			--     luasnip.expand_or_jump()
			-- elseif has_words_before() then
			--     cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function (fallback)
			local luasnip = require("luasnip")
			if cmp.visible() then
				cmp.select_prev_item()
			-- elseif luasnip.jumpable(-1) then
			--     luasnip.jump(-1)
			else
				fallback()
			end
		end, {"i", "s"}),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'nvim_lsp_signature_help' },
		-- { name = 'vsnip' }, -- For vsnip users.
		{ name = 'luasnip' }, -- For luasnip users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
	}, {
		-- { name = 'buffer' },
	})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = 'buffer' },
	})
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local lua_workspace = { vim.fn.getcwd() }
-- for _, x in pairs(vim.api.nvim_get_runtime_file("", true)) do
--     table.insert(lua_workspace, x)
-- end

-- check :help lspconfig-server-configurations
-- check ~/.local/share/nvim/site/pack/packer/start
local lsp_settings = {
	sumneko_lua = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = 'LuaJIT',
				-- Setup your lua path
				-- path = runtime_path,
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = {'vim', 'awesome'},
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				-- library = vim.api.nvim_get_runtime_file("", true)
				-- library = lua_workspace
				library = {
					vim.fn.getcwd(),
					'/usr/share/awesome/lib',
				}
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		}
	},
	clangd = {},
	pyright = {},
	texlab = {},

	-- use rust plugin instead?
	-- rust_analyzer = {
	--     ["rust-analyzer"] = {
	--         server = {
	--             extraEnv = {
	--                 RA_LOG = "info"
	--             }
	--         }
	--     }
	-- },
}


for lsp, setting in pairs(lsp_settings) do
	require'lspconfig'[lsp].setup {
		settings = setting,
		capabilities = capabilities,
	}
end

-- lsp from aur didn't work :(
require'lspconfig'.omnisharp.setup {
	capabilities = capabilities,
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
