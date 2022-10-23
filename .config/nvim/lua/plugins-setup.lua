require('packer').startup(function(use)
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

	-- peek register
	-- use 'junegunn/vim-peekaboo'

	-- use 'vimwiki/vimwiki'

    -- LSP, snippet, and autocomplete
    use 'neovim/nvim-lspconfig'
    use 'nvim-tree/nvim-tree.lua'
    use 'neovim/nvim-lspconfig'

    use 'hrsh7th/nvim-cmp'

	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-nvim-lsp-signature-help'
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

require("nvim-tree").setup()
require("luasnip.loaders.from_snipmate").lazy_load()
vim.api.nvim_create_autocmd({'BufWritePost'}, {
	pattern = {'*.snippets'},
	callback = require("luasnip.loaders.from_snipmate").lazy_load,
})

