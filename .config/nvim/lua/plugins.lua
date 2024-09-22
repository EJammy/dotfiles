-- To Add: 
-- https://github.com/notomo/gesture.nvim

local function open_nvim_tree(data)
   -- buffer is a directory
   local directory = vim.fn.isdirectory(data.file) == 1
   if not directory then
      return
   end

   -- change to the directory
   vim.cmd.cd(data.file)

   -- open the tree
   require("nvim-tree.api").tree.open()
end
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })


-- # git

-- # lsp, snippet, and autocomplete

-- # Eye candy
-- require('incline').setup {
--    window = {
--       margin = {
--          horizontal = 0,
--          vertical = 0
--       }
--    }
-- }
local function lualine_bool_func(fn, true_str, false_str)
   return function ()
      if fn() then
         return true_str
      end
      return false_str
   end
end


-- # File type specific

-- local gesture = require("gesture")
-- vim.keymap.set("n", "<LeftDrag>", gesture.draw, { silent = true })
-- vim.keymap.set("n", "<LeftRelease>", gesture.finish, { silent = true })
-- gesture.register({
--    name = "scroll to bottom",
--    inputs = { gesture.up(), gesture.down() },
--    action = "normal! G",
-- })
-- gesture.register {
--    name = "Diff view",
--    inputs = { gesture.up(), gesture.left(), gesture.down() },
--    action = 'DiffviewOpen'
-- }
-- gesture.register {
--    name = "close tab",
--    inputs = { gesture.left(), gesture.right(), gesture.left() },
--    action = 'tabclose'
-- }
-- gesture.register {
--    name = 'scroll',
--    match = function(ctx)
--       return #ctx.inputs == 1
--    end,
--    can_match = function(ctx)
--       return #ctx.inputs == 1
--    end,
--    action = function(ctx)
--       local input = ctx.inputs[1]
--       if input.direction == 'UP' then
--       print('normal! ' .. input.length .. '\\<c-y>')
--       end
--       if input.direction == 'DOWN' then
--          vim.cmd('exe "normal! ' .. input.length .. '\\<c-e>"')
--       end
--
--    end,
-- }
-- gesture.register({
--    name = "close gesture traced windows",
--    match = function(ctx)
--       local last_input = ctx.inputs[#ctx.inputs]
--       return last_input and last_input.direction == "UP"
--    end,
--    can_match = function(ctx)
--       local first_input = ctx.inputs[1]
--       return first_input and first_input.direction == "RIGHT"
--    end,
--    action = function(ctx)
--       table.sort(ctx.window_ids, function(a, b)
--          return a > b
--       end)
--       for _, window_id in ipairs(vim.fn.uniq(ctx.window_ids)) do
--          vim.api.nvim_win_close(window_id, false)
--       end
--    end,
-- })


vim.cmd [[
   " VimTeX
   "
   " This is necessary for VimTeX to load properly. The "indent" is optional.
   " Note that most plugin managers will do this automatically.
   " filetype plugin indent on

   " This enables Vim's and neovim's syntax-related features. Without this, some
   " VimTeX features will not work (see ":help vimtex-requirements" for more
   " info).
   "syntax enable

   " Viewer options: One may configure the viewer either by specifying a built-in
   " viewer method:
   " let g:vimtex_view_method = 'zathura'

   " Or with a generic interface:
   let g:vimtex_view_general_viewer = 'okular'
   let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'

   " VimTeX uses latexmk as the default compiler backend. If you use it, which is
   " strongly recommended, you probably don't need to configure anything. If you
   " want another compiler backend, you can change it as follows. The list of
   " supported backends and further explanation is provided in the documentation,
   " see ":help vimtex-compiler".
   " let g:vimtex_compiler_method = 'latexrun'
   ]]
--vim.keymap.del('i', ']]')

-- TODO: move this to ftplugin?
vim.cmd [[
au FileType scheme call rainbow#load()
]]

return {
   { 'wbthomason/packer.nvim' },

   -- dependency for many plugins
   { 'nvim-lua/plenary.nvim' },
   { 'nvim-tree/nvim-web-devicons' },

   -- # Essentials
   { 'nvim-telescope/telescope.nvim', branch = '0.1.x' } ,
   { 'numToStr/Comment.nvim', opts = {} },
   -- { "klen/nvim-config-local" },
   {
      "kylechui/nvim-surround",
      opts = {},
      version = "*", -- for stability; omit to use `main` branch for the latest features
   },
   {
      'nvim-tree/nvim-tree.lua',
      -- keys = { { '<leader>we' } },
      opts = {
         filters = {
            dotfiles = true,
            -- Unity meta files
            custom = { '.\\+.meta' },
         },
      },
   },
   { 'folke/which-key.nvim', opts = {}, version = '2.*.*', },
   { 'NMAC427/guess-indent.nvim', opts = {} },

   { 'nvim-treesitter/nvim-treesitter' },
   { 'nvim-treesitter/nvim-treesitter-context' },

   { 'simrat39/symbols-outline.nvim', opts = {} },
   -- { 'stevearc/aerial.nvim' },

   {
      'petertriho/nvim-scrollbar',
      enabled = false,
      config = function()
         require("scrollbar").setup {
            marks = {
               Cursor = {
                  text = ''
               }
            }
         }
         require("scrollbar.handlers.gitsigns").setup()
      end
   },
   { 'dstein64/nvim-scrollview', opts = { column = 1 } },
   { 'vimwiki/vimwiki', enabled = false },

   -- # Git
   { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' } ,
   {
      'lewis6991/gitsigns.nvim',
      opts = {
         current_line_blame = false,
         current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = 'right_align',
            -- 'eol' | 'overlay' | 'right_align'
            delay = 0,
         },
      }
   },
   { 'tpope/vim-fugitive' },

   -- # LSP, snippet, and autocomplete
   { 'neovim/nvim-lspconfig' },
   { 'williamboman/mason.nvim', opts = {} },

   { 'hrsh7th/nvim-cmp' },
   { 'hrsh7th/cmp-path' },
   { 'hrsh7th/cmp-nvim-lsp' },
   -- { 'hrsh7th/cmp-nvim-lsp-signature-help' },
   { 'hrsh7th/cmp-cmdline' },
   -- { 'hrsh7th/cmp-cmdline' },
   -- { 'hrsh7th/cmp-buffer' },

   -- { 'Issafalcon/lsp-overloads.nvim'},
   {
      'ray-x/lsp_signature.nvim',
      opts = {
         hint_prefix = ">> ",
         toggle_key = '<m-k>',
         select_signature_key = '<m-j>'
      }
   },

   {
      "L3MON4D3/LuaSnip",
      version = "v2.*" ,
      opts = {
         region_check_events = 'CursorMoved',
         delete_check_events = 'TextChanged',
      },
      config = function(_, opts)
         require('luasnip').setup(opts)
         require("luasnip.loaders.from_snipmate").lazy_load()
         vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
            pattern = { '*.snippets' },
            callback = require("luasnip.loaders.from_snipmate").lazy_load,
         })
      end
   },
   { 'saadparwaiz1/cmp_luasnip' },

   { 'folke/trouble.nvim' },

   { "rcarriga/nvim-dap-ui", opts = {}, dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} },
   { 'theHamsta/nvim-dap-virtual-text', opts = {} },

   -- # Eye candy
   { 'norcalli/nvim-colorizer.lua', opts = {} },
   -- TODO
   {
      "lukas-reineke/indent-blankline.nvim",
      version = "v2.*",
      opts = {
         -- for example, context is off by default, use this to turn it on
         show_current_context = true,
         show_current_context_start = true,
      }
   },
   { 'karb94/neoscroll.nvim', opts = {} },
   { "b0o/incline.nvim" },
   {
      'nvim-lualine/lualine.nvim',
      opts = function() return {
         options = {
            disabled_filetypes = {
               'NvimTree',
               'DiffviewFileHistory',
               'DiffviewFiles',
               'help',
               statusline = {},
               winbar = {},
            },
            globalstatus = true,
            refresh = {
               statusline = 1000,
               tabline = 1000,
               winbar = 1000,
            }
         },
         sections = {
            lualine_a = {
               'mode',
               lualine_bool_func(
               function() return require('luasnip').jumpable(1) end,
               '<C-L>', ''
               ),
               lualine_bool_func(
               require('luasnip').expandable,
               'snip', ''
               ),
            },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = {
               {'filename', path = 1}
            },
            lualine_x = {
               'encoding', 'fileformat', 'filetype',
            },
            lualine_y = {
               function()
                  local names = {}
                  for _, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
                     table.insert(names, server.name)
                  end
                  return " [" .. table.concat(names, " ") .. "]"
               end
            },
            lualine_z = { 'progress', 'location' }
         },
         winbar = {
            lualine_a = {
               lualine_bool_func(
               function() return require('luasnip').jumpable(1) end,
               '<C-L>', ''
               ),
               lualine_bool_func(
               require('luasnip').expandable,
               'snip', ''
               ),
            },
            lualine_z = { 'filename' }
         },
         inactive_winbar = {
            lualine_z = { 'filename' }
         },
         tabline = {
         },
         extensions = {}
      } end, -- end opts = function() return
      dependencies = { 'nvim-tree/nvim-web-devicons' }
   },
   {
      "catppuccin/nvim", name = "catppuccin", priority = 1000,
      opts = { transparent_background = false }
   },
   { "olimorris/onedarkpro.nvim" },

   -- # Nonsense
   { 'Eandrju/cellular-automaton.nvim' },
   { 'notomo/gesture.nvim' },
   { 'wakatime/vim-wakatime' },

   -- # File type specific
   { "folke/lazydev.nvim", ft = "lua", opts = {} },
   { 'lervag/vimtex' },
   { 'frazrepo/vim-rainbow' },
   {
      'simrat39/rust-tools.nvim',
      ft = 'rust',
      config = function()
         require'rust-tools'.setup {
            server = {
               on_attach = require('lsp').on_attach
            },
         }
      end
   },
   -- { 'mattn/emmet-vim' },
   { 'tikhomirov/vim-glsl' },
   -- { 'ray-x/go.nvim', opts = {} },
   { 'leoluz/nvim-dap-go', opts = {} },
}
