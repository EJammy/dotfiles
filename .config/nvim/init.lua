-- :h lua-guide
-- TODO:
-- vim.diagnostic.setqflist()
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

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

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

vim.opt.viewoptions:remove('curdir')
vim.api.nvim_create_autocmd('BufWinLeave', { command = 'silent! mkview' })
vim.api.nvim_create_autocmd('BufWinEnter', { command = 'silent! loadview' })

vim.g.mapleader = ' '

vim.keymap.set('n', ' r1', '<cmd>so %<cr>')
vim.keymap.set('n', ' r2', reload_plugins)
vim.keymap.set('n', ' r3', reload_ftconfig)

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
   local lazyrepo = "https://github.com/folke/lazy.nvim.git"
   local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
   if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
         { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
         { out, "WarningMsg" },
         { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
   end
end
vim.opt.rtp:prepend(lazypath)

require 'options'

-- useless
require 'plugins'

-- Setup lazy.nvim
require("lazy").setup({
   spec = {
      -- import your plugins
      { import = "plugins" },
   },
   -- Configure any other settings here. See the documentation for more details.
   -- colorscheme that will be used when installing plugins.
   install = { colorscheme = { "habamax" } },
   -- automatically check for plugin updates
   -- checker = { enabled = true },
})
require 'extra'
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

-- TODO: move me
vim.api.nvim_create_autocmd("FileType", { pattern = "TelescopeResults", command = [[setlocal nofoldenable]] })
-- require('guess-indent').setup()


-- lilypond dictionary. copied from :h cmp-dictionary
-- TODO: move

vim.api.nvim_create_autocmd("BufEnter", {
   pattern = "*",
   callback = function(ev)
      local dict = {
         ft = {
            lilypond = vim.fn.glob(vim.fn.expand('$LILYDICTPATH') .. '/*', true, true),
         },
      }

      local paths = dict.ft[vim.bo.filetype] or {'~/.local/share/nvim/lazy/nvim-lilypond-suite/lilywords/scales'}
      -- vim.list_extend(paths, dict["*"])
      require("cmp_dictionary").setup({
         paths = paths,
         exact_length = 2,
      })
   end
})
local dap = require("dap")
dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
}
local dap = require("dap")
dap.configurations.cpp = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args = {}, -- provide arguments if needed
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name = "Select and attach to process",
    type = "gdb",
    request = "attach",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    pid = function()
      local name = vim.fn.input('Executable name (filter): ')
      return require("dap.utils").pick_process({ filter = name })
    end,
    cwd = '${workspaceFolder}'
  },
  {
    name = 'Attach to gdbserver :1234',
    type = 'gdb',
    request = 'attach',
    target = 'localhost:1234',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}'
  }
}
