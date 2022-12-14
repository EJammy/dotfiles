-- TODO:
-- Which-key
--  bug report: terminal mode
--  disable all insert mode maps
-- cmp mappings good?
-- cmp documentations
--
-- which-key for nvim-tree?
-- git blame
-- git gutter
-- git diff
-- git compare w/ last commit
-- focus mode
-- vim wiki
-- telescope
-- startup screen
-- return cursor pos
-- check gh stars

-- https://github.com/nanotee/nvim-lua-guide
-- TOC?
-- different os
-- http://neovimcraft.com

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

-- :h last-position-jump
vim.cmd([[
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif
  ]])


vim.g.mapleader = ' '

vim.keymap.set('n', ' r1', '<cmd>so %<cr>')
vim.keymap.set('n', ' r2', reload_plugins)
vim.keymap.set('n', ' r3', reload_ftconfig)


require 'plugins'
require 'lsp'
require 'lsp-config'
require 'options'
require 'keymaps'


local function open_snippet()
    vim.cmd('e ' .. vim.fn.stdpath('config') .. '/snippets/' .. vim.bo.filetype .. '.snippets')
end
vim.api.nvim_create_user_command('Snippets', open_snippet, {})

local function open_ft_settings()
    vim.cmd('e ' .. vim.fn.stdpath('config') .. '/ftplugin/' .. vim.bo.filetype .. '.lua')
end
vim.api.nvim_create_user_command('FTSettings', open_ft_settings, {})


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

