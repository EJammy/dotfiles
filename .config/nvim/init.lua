-- TODO:
-- undo dir
-- which-key for nvim-tree customize plugins
--
-- util = require 'utils'

-- plan: put everythin in one file, then seperate

-- path for syncing vimwiki

--  installation notes:
--  set g:gdrive_path for path to google drive (for vim wiki)
-- 
--  hint: gf to go to file, /-->
-- 
--  TODO:
--  https://github.com/nanotee/nvim-lua-guide
--  TOC?
-- 	fix for windows
-- 	compiling
-- 	set scripts for installing dotfiles
-- 	tree (Nerdtree or Fern)
-- 	telescope, startup screen
-- 	<cmd>
-- 
-- 	/usr/share/vim/vim82/defaults.vim
-- 
--  if empty(glob('~/tmp'))
--      silent !mkdir ~/tmp
--  endif

require 'plugins'

vim.g.gdrive_path='~/Files/'

-- vim.cmd('source $VIMRUNTIME/defaults.vim')

--> Options
local options = {
	number = true,
	relativenumber = true,

	tabstop = 4,
	shiftwidth = 0, -- use value from tabstop
	smarttab = true,
	ignorecase = true,

	-- expandtab,
	-- expandtab = true,

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

	smartcase = true,

	completeopt = 'menu,menuone,noselect',

	-- fix colors
	termguicolors = true,

	-- fold method
	foldmethod = 'syntax'
}

for _, i in pairs(options) do
	vim.opt[_] = i
end

vim.cmd('source ' .. vim.fn.stdpath('config') .. '/' .. 'settings.vim')

-- if vim.g.vscode then print('foo') end

-- for using gf in init.lua
vim.opt.path:append(vim.fn.stdpath('config'))
vim.opt.path:append(vim.fn.stdpath('config') .. '/lua')

--> keymaps
local map_key = vim.api.nvim_set_keymap
local function map_nvo(lhs, rhs)
	map_key('n', lhs, rhs, {})
	map_key('v', lhs, rhs, {})
	map_key('o', lhs, rhs, {})
end


local function map_leader(mode, lhs, rhs)
	map_key(mode, '<leader>' .. lhs, rhs, {})
end

map_key('!', 'fd', '<esc>', {})
map_key('!', 'jk', '<esc>', {})
map_key('!', 'kj', '<esc>', {})

map_nvo('<c-n>', '5j')
map_nvo('<c-p>', '5k')

map_key('n', '<c-s>', '<cmd>w<cr>', {})
map_key('!', '<c-s>', '<cmd>w<cr>', {})

map_key('n', '<m-o>', '<c-o>', {})
map_key('n', '<m-i>', '<c-i>', {})

map_key('n', '<c-k>', '<c-o>', {})
map_key('n', '<c-j>', '<c-i>', {})

vim.g.leader = ' '

local leader_keymaps = {
	s = '<cmd>w<cr>',

	-- fold around brackets
	zf = 'zfa}',

	-- yank to system clipboard
	y = 'gg"+yG<c-o',
	p = {'"+p', {'n', 'v'} },

	-- buffers
	j = '<cmd>bn<cr>',
	k = '<cmd>bp<cr>',
	x = '<cmd>bd<cr>',

	we = '<cmd>NvimTreeToggle<CR>',

	-- clear highlights
	h = '<cmd>nohls<cr>',

}

for lhs, rhs in pairs(leader_keymaps) do
	if type(rhs) == type({}) then
		for _, mode in pairs(rhs[2]) do
			map_leader(mode, lhs, rhs[1])
		end
	else
		map_leader('n', lhs, rhs)
	end
end

map_key('n', '<leader>/', '<plug>NERDCommenterToggle', {})
map_key('v', '<leader>/', '<plug>NERDCommenterToggle', {})
-- <c-/>
map_key('n', '<c-_>', '<plug>NERDCommenterToggle', {})
map_key('v', '<c-_>', '<plug>NERDCommenterToggle', {})

map_key('t', '<c-w>', '<c-\\><c-n><c-w>', {})
map_key('t', 'fd', '<c-\\><c-n>', {})

vim.cmd('au vimrc BufWinEnter,WinEnter term://* startinsert')
vim.cmd('au vimrc BufWinEnter,WinEnter toggle_term startinsert')
-- vim.api.nvim_create_autocmd()

vim.cmd('au vimrc BufWinEnter *.rs RustStartStandaloneServerForBuffer')
vim.cmd('au vimrc BufWinEnter *.rs echo "Warning: automatically starting standalone file mode"')

vim.cmd('command! Settings vsplit ' .. vim.fn.stdpath('config') .. "/init.lua")

local function open_snippet()
	vim.cmd('e ~/.config/nvim/snippets/' .. vim.bo.filetype .. '.snippets')
end
vim.api.nvim_create_user_command('Snippets', open_snippet, {})
-- local function open_ft_settings()
--     vim.cmd('e ~/.config/nvim/snippets/' .. vim.bo.filetype .. '.snippets')
-- end
vim.api.nvim_create_user_command('Snippets', open_snippet, {})

-- new undo block at period
-- imap . .<c-g>u

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
vim.api.nvim_set_keymap('t', '<leader>wt', '<cmd>lua Toggle_term("toggle_term")<cr>', {})

--> goyo
vim.g.goyo_width="80%"
vim.g.goyo_height="80%"
map_leader('n', 'ff', '<cmd>Goyo<cr>')
map_leader('n', 'gg', '<cmd>Goyo<cr>')

require("luasnip.loaders.from_snipmate").lazy_load()
vim.api.nvim_create_autocmd({'BufWritePost'}, {
	pattern = {'*.snippets'},
	callback = require("luasnip.loaders.from_snipmate").lazy_load,
})

require("luasnip.loaders.from_snipmate").lazy_load({paths = "~/.config/nvim/snippets"})

if not vim.g.vscode then
	require('lsp')
	require('rust-tools').setup({})
end

-- require'nvim-tree'.setup()
-- require'feline'.setup()
