-- :h lua-guide
-- TODO:
-- Which-key
--  bug report: terminal mode
--  disable all insert mode maps
-- cmp mappings good?
-- cmp documentations
--
-- LSP quickfix list :h vim.diagnostic.setloclist
--
-- tree sitter
-- which-key for nvim-tree?
-- git blame
-- git gutter
-- git diff
-- git compare w/ last commit
-- focus mode
-- vim wiki
-- telescope
-- startup screen
-- check gh stars
-- buffer line

-- https://github.com/nanotee/nvim-lua-guide
-- TOC?
-- different os
-- http://neovimcraft.com
--
--[[
https://github.com/f-person/git-blame.nvim
 https://github.com/APZelos/blamer.nvim
https://github.com/lewis6991/gitsigns.nvim

https://www.reddit.com/r/neovim/comments/ug96n9/which_tools_do_you_use_for_git_conflicts/
https://www.reddit.com/r/neovim/comments/iwfv18/git_integration/
https://www.reddit.com/r/neovim/comments/ts8app/what_are_the_must_have_git_plugs_in_your_opinion/
]]--

local function reload_ftconfig()
   -- vim.cmd [[ set all& ]]
   local function try_load(file)
      if vim.fn.empty(vim.fn.glob(file)) == 0 then dofile(file) end
   end
   try_load(vim.fn.stdpath('config') .. '/ftplugin/' .. vim.bo.filetype .. '.lua')
   try_load(vim.fn.stdpath('config') .. '/ftplugin/' .. vim.bo.filetype .. '.vim')
end

local function reload_plugins()
   vim.cmd [[ PackerSync ]]
end

vim.api.nvim_create_autocmd('BufWinLeave', { command = 'silent! mkview' })
vim.api.nvim_create_autocmd('BufWinEnter', { command = 'silent! loadview' })

vim.g.mapleader = ' '

vim.keymap.set('n', ' r1', '<cmd>so %<cr>')
vim.keymap.set('n', ' r2', reload_plugins)
vim.keymap.set('n', ' r3', reload_ftconfig)

require 'options'
require 'plugins'
require 'lsp'
require 'lsp-config'
require 'keymaps'

local function open_snippet()
   vim.cmd('e ' .. vim.fn.stdpath('config') .. '/snippets/' .. vim.bo.filetype .. '.snippets')
end
vim.api.nvim_create_user_command('Snippets', open_snippet, {})

local function open_ft_settings()
   vim.cmd('e ' .. vim.fn.stdpath('config') .. '/ftplugin/' .. vim.bo.filetype .. '.lua')
end
vim.api.nvim_create_user_command('FTSettings', open_ft_settings, {})

local function open_settings()
   vim.cmd('e ' .. vim.fn.stdpath('config') .. '/init.lua')
end
vim.api.nvim_create_user_command('Settings', open_settings, {})

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

vim.keymap.set('t', '<c-w>', '<c-\\><c-n><c-w>')
vim.keymap.set('t', 'fd', '<c-\\><c-n>')

vim.cmd('au BufWinEnter,WinEnter term://* startinsert')
vim.cmd('au BufWinEnter,WinEnter toggle_term startinsert')

vim.api.nvim_set_keymap('n', '<leader>wt', '<cmd>lua Toggle_term("toggle_term")<cr>', {})
-- vim.api.nvim_set_keymap('t', '<leader>wt', '<cmd>lua Toggle_term("toggle_term")<cr>', {})

