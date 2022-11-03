require('packer').startup(function(use)

    use 'nvim-lua/plenary.nvim'
    use 'wbthomason/packer.nvim'

    -- Essentials
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    use {
        "kylechui/nvim-surround",
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require("nvim-surround").setup {
                -- Configuration here, or leave empty to use defaults
            }
        end
    }

	use {
		'folke/which-key.nvim',
		config = function() require("which-key").setup{}
		end
	}

	use 'nvim-treesitter/nvim-treesitter'
	use 'nvim-treesitter/nvim-treesitter-context'
    use { 'nvim-telescope/telescope.nvim', branch = '0.1.x' }

    use 'simrat39/symbols-outline.nvim'
    -- use 'stevearc/aerial.nvim'

	-- peek register
	-- use 'junegunn/vim-peekaboo'

	-- use 'vimwiki/vimwiki'

    -- LSP, snippet, and autocomplete
    use 'neovim/nvim-lspconfig'
    use 'nvim-tree/nvim-tree.lua'
    use 'neovim/nvim-lspconfig'

    use 'hrsh7th/nvim-cmp'

    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
    use 'hrsh7th/cmp-cmdline'
    -- use 'hrsh7th/cmp-cmdline'
	-- use 'hrsh7th/cmp-buffer'

	-- use { 'Issafalcon/lsp-overloads.nvim'}

    use {"L3MON4D3/LuaSnip", tag = "v<CurrentMajor>.*"}
    use 'saadparwaiz1/cmp_luasnip'

    -- Eye candy
    use {
        "catppuccin/nvim",
        as = "catppuccin",
        config = function()
            vim.g.catppuccin_flavour = "latte" -- latte, frappe, macchiato, mocha
            require("catppuccin").setup()
            vim.api.nvim_command "colorscheme catppuccin"
        end
    }

    -- File specific
    use 'folke/neodev.nvim'
    use 'lervag/vimtex'
	-- use 'simrat39/rust-tools.nvim'

end)

require("nvim-tree").setup({
    filters = {
        dotfiles = true,
        custom = {'.\\+.meta'},
    },
})


require("luasnip.loaders.from_snipmate").lazy_load()
vim.api.nvim_create_autocmd({'BufWritePost'}, {
	pattern = {'*.snippets'},
	callback = require("luasnip.loaders.from_snipmate").lazy_load,
})

vim.keymap.set('n', '<a-p>', function() require('telescope.builtin').builtin{} end)

require("symbols-outline").setup({})

vim.keymap.set('n', '<leader>wr', '<cmd>SymbolsOutline<cr>')

vim.cmd [[
" VimTeX
"
" This is necessary for VimTeX to load properly. The "indent" is optional.
" Note that most plugin managers will do this automatically.
filetype plugin indent on

" This enables Vim's and neovim's syntax-related features. Without this, some
" VimTeX features will not work (see ":help vimtex-requirements" for more
" info).
syntax enable

" Viewer options: One may configure the viewer either by specifying a built-in
" viewer method:
" let g:vimtex_view_method = 'zathura'

" Or with a generic interface:
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'

" VimTeX uses latexmk as the default compiler backend. If you use it, which is
" strongly recommended, you probably don't need to configure anything. If you
" want another compiler backend, you can change it as follows. The list of
" supported backends and further explanation is provided in the documentation,
" see ":help vimtex-compiler".
let g:vimtex_compiler_method = 'latexrun'

]]
