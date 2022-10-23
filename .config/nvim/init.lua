-- TODO:
-- which-key for nvim-tree?
-- code map: simrat39/symbols-outline.nvim
-- git blame
-- git gutter
-- git diff
-- git compare w/ last commit
-- focus mode
-- peekaboo
-- vim wiki
-- telescope
-- startup screen
-- return cursor pos
-- check gh stars

-- https://github.com/nanotee/nvim-lua-guide
-- TOC?
-- different os
-- http://neovimcraft.com

local function reload_config()
    local modules = {
        'options',
        'plugins-setup',
        'init-lsp',
        'options',
        'keymaps',
    }
    -- vim.cmd [[ set all& ]]
    for _, module in ipairs(modules) do
        package.loaded[module] = nil
    end
    dofile(vim.fn.stdpath('config') .. '/init.lua')
end


local function reload_plugins()
    vim.cmd [[ PackerSync ]]
end

vim.keymap.set('n', ' r1', reload_config)
vim.keymap.set('n', ' r2', reload_plugins)

require 'options'
require 'plugins-setup'
require 'init-lsp'
require 'options'
require 'keymaps'

local function open_snippet()
	vim.cmd('e ~/.config/nvim/snippets/' .. vim.bo.filetype .. '.snippets')
end
vim.api.nvim_create_user_command('Snippets', open_snippet, {})
-- local function open_ft_settings()
--     vim.cmd('e ~/.config/nvim/snippets/' .. vim.bo.filetype .. '.snippets')
-- end

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

