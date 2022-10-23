local map_key = vim.keymap.set

vim.g.leader = ' '

map_key('n', '<c-s>', '<cmd>w<cr>')
map_key('!', '<c-s>', '<cmd>w<cr>')

map_key('!', 'qw', '{')
map_key('!', 'wq', '}')
map_key('!', 'qq', '(')
map_key('!', 'ww', ')')

map_key('!', 'zz', '\'')
map_key('!', 'xx', '\"')

map_key('!', 'fd', '<esc>')
map_key('!', 'jk', '<esc>')
map_key('!', 'kj', '<esc>')

map_key('', '<c-n>', '5j')
map_key('', '<c-p>', '5k')

map_key('n', '<c-_>', '<plug>(comment_toggle_linewise_current)')
map_key('v', '<c-_>', '<plug>(comment_toggle_linewise_visual)')

-- remapping tab
-- map_key('n', '<m-o>', '<c-o>', {})
-- map_key('n', '<m-i>', '<c-i>', {})
--
-- map_key('n', '<c-k>', '<c-o>', {})
-- map_key('n', '<c-j>', '<c-i>', {})

-- local function toggle_line_number()
--     vim.o
-- end

vim.g.mapleader = ' '

local leader_keymaps = {
    s = '<cmd>w<cr>',

    -- fold around brackets
    zf = 'zfa}',

    -- yank to system clipboard
    y = {'"+y', {'n', 'v'} },
    p = {'"+p', {'n', 'v'} },

    -- buffers
    j = '<cmd>bn<cr>',
    k = '<cmd>bp<cr>',
    x = '<cmd>bd<cr>',

    we = '<cmd>NvimTreeToggle<CR>',

    -- clear highlights
    h = '<cmd>nohls<cr>',

    qc1 = '<cmd>colorscheme tokyonight<cr>',
    qc2 = '<cmd>colorscheme catppuccin<cr>',
    qn = function()
        vim.o.number = not vim.o.number
        vim.o.rnu = not vim.o.rnu
    end,
    ql1 = '<cmd>lua vim.diagnostic.config({ virtual_text = false })<cr>',
    ql2 = '<cmd>lua vim.diagnostic.config({ virtual_text = true })<cr>',
}


for lhs, rhs in pairs(leader_keymaps) do
    if type(rhs) == 'table' then
        map_key(rhs[2], '<leader>' .. lhs, rhs[1])
    else
        map_key('n', '<leader>' .. lhs, rhs)
    end
end

