-- TODO:
-- undo dir
-- which-key for nvim-tree customize plugins
--
-- util = require 'utils'

-- plan: put everythin in one file, then seperate

-- path for syncing vimwiki
vim.g.gdrive_path='~/Files/'

vim.cmd('source ' .. vim.fn.stdpath('config') .. '/' .. 'settings.vim')


--> Options
local options = {
	number = true,
	relativenumber = true,

	tabstop = 4,
	shiftwidth = 0, -- use value from tabstop
	smarttab = true,
	ignorecase = true,
	-- expandtab,

	-- enable mouse
	mouse = 'a',

	-- warp words
	linebreak = true,

	-- autoread on file change
	autoread = true,

	-- don't wrap search
	wrapscan = false,

	-- don't wrap lines
	wrap = false,

	scrolloff = 6,
	undofile = true,

	completeopt='menu,menuone,noselect',
}

for _, i in pairs(options) do
	vim.opt[_] = i
end

-- if vim.g.vscode then print('foo') end

vim.opt.path:append(vim.fn.stdpath('config'))
vim.opt.path:append(vim.fn.stdpath('config') .. '/lua')



--> keymaps
local map_key = vim.api.nvim_set_keymap
map_key('t', '<c-w>', '<c-\\><c-n><c-w>', {})
map_key('t', 'fd', '<c-\\><c-n>', {})
vim.cmd('au vimrc BufWinEnter,WinEnter term://* startinsert')
vim.cmd('au vimrc BufWinEnter,WinEnter toggle_term startinsert')

vim.cmd('au vimrc BufWinEnter *.rs RustStartStandaloneServerForBuffer')
vim.cmd('au vimrc BufWinEnter *.rs echo "Warning: automatically starting standalone file mode"')


vim.cmd('command! Settings vsplit ' .. vim.fn.stdpath('config') .. "/init.lua")

vim.g.leader = ' '

function Toggle_term(termname)
	local pane = vim.fn.bufwinid(termname)
	local buf = vim.fn.bufexists(termname)
	if pane > -1 then
		-- pane is visible
		vim.api.nvim_win_hide(pane)
	elseif buf > 0 then
		-- buffer loaded, not visible
		vim.cmd('botright 12split ' .. termname)
	else
		-- create buffer
		vim.cmd("botright 12split term://zsh")
		vim.cmd("file " .. termname)
		vim.opt.buflisted = false
	end
end

vim.api.nvim_set_keymap('n', '<leader>wt', '<cmd>lua Toggle_term("toggle_term")<cr>', {})



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

	use {
		'folke/which-key.nvim',
		config = function()
			require("which-key").setup{}
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

	use 'hrsh7th/cmp-vsnip'
	use 'hrsh7th/vim-vsnip'
	--
	-- ray-x/lsp_signature.nvim
	use 'simrat39/rust-tools.nvim'

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


if not vim.g.vscode then
	require('lsp')
	require('rust-tools').setup({})
end

-- require'nvim-tree'.setup()
-- require'feline'.setup()
