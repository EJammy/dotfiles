--> Plugins
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local packer_bootstrap
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'


	use 'tpope/vim-surround'

	use 'scrooloose/nerdcommenter'

if not vim.g.vscode then
	use 'vimwiki/vimwiki'
	use 'lervag/vimtex'

	use {
		'folke/which-key.nvim',
		config = function() require("which-key").setup{}
		end
	}

	use {
		'kyazdani42/nvim-tree.lua',
		requires = {
			'kyazdani42/nvim-web-devicons', -- optional, for file icon
		},
		config = function()
			require'nvim-tree'.setup{}
		end
	}

	--focus mode
	use 'junegunn/goyo.vim'

	-- peek register
	use 'junegunn/vim-peekaboo'

	use 'neovim/nvim-lspconfig'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-nvim-lsp-signature-help'

	use { 'Issafalcon/lsp-overloads.nvim'}

	-- use 'hrsh7th/cmp-vsnip'
	-- use 'hrsh7th/vim-vsnip'
	use 'L3MON4D3/LuaSnip'
	use 'saadparwaiz1/cmp_luasnip'

	--
	-- ray-x/lsp_signature.nvim
	use 'simrat39/rust-tools.nvim'
	-- use 'OmniSharp/omnisharp-vim'

	-- use {'neoclide/coc.nvim', branch = 'release'}

	-- themes
	use 'NLKNguyen/papercolor-theme'
	use 'joshdick/onedark.vim'
	use 'altercation/vim-colors-solarized'
	use 'ghifarit53/tokyonight-vim'
	use 'cocopon/iceberg.vim'
	use 'drewtempelmeyer/palenight.vim'
end


	--[[

" Plug 'feline-nvim/feline.nvim'
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'plasticboy/vim-markdown'
Plug 'dpelle/vim-LanguageTool'
Plug 'junegunn/vim-emoji'
Plug 'tpope/vim-fugitive'
Plug 'neovim/nvim-lspconfig'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'akinsho/bufferline.nvim'

" file tree

" Plug 'ycm-core/YouCompleteMe'
" Plug 'neoclide/coc.nvim'

	]]


	-- Automatically set up your configuration after cloning packer.nvim
	if packer_bootstrap then
		require('packer').sync()
	end
end)



