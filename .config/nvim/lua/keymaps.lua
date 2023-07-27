local M = {}

local map_key = vim.keymap.set

local wk = require('which-key')

map_key('n', '<m-;>', ':lua =')
map_key('n', '<m-cr>', ':lua ')

map_key('n', '<c-s>', '<cmd>w<cr>')
map_key('!', '<c-s>', '<cmd>w<cr>')

map_key('', 'H', '^')
map_key('', 'L', '$')

-- map_key('!', 'qw', '{')
-- map_key('!', 'wq', '}')
-- map_key('!', 'qq', '(')
-- map_key('!', 'ww', ')')

-- map_key('!', 'zz', '\'')
-- map_key('!', 'xx', '\"')

map_key('!', 'fd', '<esc>')
map_key('!', 'jk', '<esc>')
map_key('!', 'kj', '<esc>')

-- map_key('', '<c-n>', '5j')
-- map_key('', '<c-p>', '5k')

-- Same as above but multiplies number
map_key('', '<c-n>', '@="5j"<cr>', { silent = true })
map_key('', '<c-p>', '@="5k"<cr>', { silent = true })

map_key('', '<c-_>', '<plug>(comment_toggle_linewise_current)')
map_key('v', '<c-_>', '<plug>(comment_toggle_linewise_visual)')
map_key('', '<c-/>', '<plug>(comment_toggle_linewise_current)')
map_key('v', '<c-/>', '<plug>(comment_toggle_linewise_visual)')

-- remapping tab in normal mode
-- map_key('n', '<m-o>', '<c-o>', {})
-- map_key('n', '<m-i>', '<c-i>', {})
--
-- map_key('n', '<c-k>', '<c-o>', {})
-- map_key('n', '<c-j>', '<c-i>', {})

local function toggle_func(fn, default)
   local opt = true
   if default == nil then opt = not default end
   return function ()
      opt = not opt
      fn(opt)
   end
end

vim.g.mapleader = ' '

local theme_opt = {'latte', 'mocha'}
local theme_id = 1

wk.register({ q = { name = 'Quick settings', {
   c = {
      function()
         theme_id = theme_id + 1
         if theme_id > #theme_opt then
            theme_id = theme_id % #theme_opt
         end
         vim.cmd('Catppuccin ' .. theme_opt[theme_id])
      end,
      'Toggle light mode'
   },
   n = {
      function()
         vim.o.number = not vim.o.number
         vim.o.rnu = not vim.o.rnu
      end,
      'Toggle line number'
   },
   w = {
      function() vim.o.wrap = not vim.o.wrap end,
      'Toggle wrap'
   },
   l = {
      name = 'LSP',
      l = {
         toggle_func(function(val) vim.diagnostic.config({virtual_text = val}) end, true),
         'Toggle virtual text'
      }
   },
}}}, { prefix = '<leader>' })


local leader_keymaps = {
   qg = {
      '<cmd>Gitsigns toggle_current_line_blame<cr>',
      'Toggle Gitsigns'
   },

   [' '] = '<cmd>WhichKey<cr>',

   s = '<cmd>w<cr>',

   -- fold around brackets
   zf = 'zfa}',

   -- yank to system clipboard
   y = {'"+y', mode = {'n', 'v'} },
   p = {'"+p', mode = {'n', 'v'} },

   -- buffers
   j = '<cmd>bn<cr>',
   k = '<cmd>bp<cr>',
   x = '<cmd>bp|bd#<cr>',

   w = { name = 'windows' },
   we = '<cmd>NvimTreeToggle<CR>',
   wr = '<cmd>SymbolsOutline<cr>',

   h = { '<cmd>nohls<cr>', 'clear highlights' },

   c = { '<cmd>ccl<cr>', 'close quickfix' },

   -- diff
   d = { name = 'diff' },
   d1 = '<cmd>diffthis<cr>',
   d2 = '<cmd>diffthis<cr>',
}

for lhs, rhs in pairs(leader_keymaps) do
   if type(rhs) == 'table' then
      if rhs[1] then
         wk.register(
            { ['<leader>' .. lhs] = { rhs[1], rhs[2] or rhs[1] } },
            { mode = rhs['mode'] or 'n' }
         )
      else
         wk.register({
            ['<leader>' .. lhs] = { name = rhs['name'] }
         })
      end
   else
      map_key('n', '<leader>' .. lhs, rhs)
   end
end

local function map_func(mode, lhs, rhs, opts)
   opts.mode = mode
   wk.register({
      [lhs] = { loadstring(rhs), rhs }
   }, opts)
end

function M.on_attach_keymaps(bufnr)
   ---- Modified from :h lspconfig-keybindings
   -- Mappings.
   -- See `:help vim.lsp.*` for documentation on any of the below functions
   local bufopts = { buffer=bufnr }
   map_func('n', 'gD', 'vim.lsp.buf.declaration()', bufopts)
   map_func('n', 'gd', 'vim.lsp.buf.definition()', bufopts)
   map_func('n', 'K', 'vim.lsp.buf.hover()', bufopts)

   map_func('n', 'gi', 'vim.lsp.buf.implementation()', bufopts)

   -- use plugin for insert mode signature help
   map_func('n', '<m-k>', 'vim.lsp.buf.signature_help()', bufopts)
   map_func('n', '<space>la', 'vim.lsp.buf.add_workspace_folder()', bufopts)
   map_func('n', '<space>lr', 'vim.lsp.buf.remove_workspace_folder()', bufopts)
   map_func('n', '<space>ll', 'print(vim.inspect(vim.lsp.buf.list_workspace_folders()))', bufopts)

   map_func('n', 'gt', 'vim.lsp.buf.type_definition()', bufopts)
   map_func('n', '<space>rn', 'vim.lsp.buf.rename()', bufopts)
   map_func('n', '<f2>', 'vim.lsp.buf.rename()', bufopts)

   map_func('n', '<space>lc', 'vim.lsp.buf.code_action()', bufopts)
   map_func('n', 'gr', 'vim.lsp.buf.references()', bufopts)
   map_func({'n', 'v'}, '<space>f', 'vim.lsp.buf.format { async = true }', bufopts)
end

vim.keymap.set('n', '<a-p>', function() require('telescope.builtin').builtin() end)
vim.keymap.set('n', '<a-f>', function() require('telescope.builtin').find_files() end)

return M
