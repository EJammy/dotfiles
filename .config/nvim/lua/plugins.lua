require('packer').startup(function(use)
   use 'wbthomason/packer.nvim'

   -- dependency for many plugins
   use 'nvim-lua/plenary.nvim'

   -- # Essentials
   use { 'nvim-telescope/telescope.nvim', branch = '0.1.x' }
   use 'numToStr/Comment.nvim'
   use "klen/nvim-config-local"
   use {
      "kylechui/nvim-surround",
      tag = "*", -- Use for stability; omit to use `main` branch for the latest features
   }
   use 'nvim-tree/nvim-tree.lua'
   use 'folke/which-key.nvim'
   use 'NMAC427/guess-indent.nvim'

   use 'nvim-treesitter/nvim-treesitter'
   use 'nvim-treesitter/nvim-treesitter-context'

   use 'simrat39/symbols-outline.nvim'
   -- use 'stevearc/aerial.nvim'

   -- use 'vimwiki/vimwiki'

   -- # Git
   use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }

   -- # LSP, snippet, and autocomplete
   use 'neovim/nvim-lspconfig'
   use 'williamboman/mason.nvim'

   use 'hrsh7th/nvim-cmp'
   use 'hrsh7th/cmp-path'
   use 'hrsh7th/cmp-nvim-lsp'
   -- use 'hrsh7th/cmp-nvim-lsp-signature-help'
   use 'hrsh7th/cmp-cmdline'
   -- use 'hrsh7th/cmp-cmdline'
   -- use 'hrsh7th/cmp-buffer'

   -- use { 'Issafalcon/lsp-overloads.nvim'}
   use { 'ray-x/lsp_signature.nvim' } --, tag = "v0.2.0" }

   use { "L3MON4D3/LuaSnip", tag = "v2.*" }
   use 'saadparwaiz1/cmp_luasnip'

   -- # Eye candy
   use 'norcalli/nvim-colorizer.lua'
   use "lukas-reineke/indent-blankline.nvim"
   use "b0o/incline.nvim"
   use {
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true }
   }
   use {
      "catppuccin/nvim",
      as = "catppuccin",
   }

   -- # Nonsense
   use 'Eandrju/cellular-automaton.nvim'

   -- # File type specific
   use 'folke/neodev.nvim'
   use 'lervag/vimtex'
   use 'frazrepo/vim-rainbow'
   use 'simrat39/rust-tools.nvim'
   use 'mattn/emmet-vim'
   use 'tikhomirov/vim-glsl'
   -- use 'ray-x/go.nvim'
end)

-- # Essentials
require('Comment').setup()
require('config-local').setup()
require('nvim-surround').setup()

require("nvim-tree").setup({
   filters = {
      dotfiles = true,
      -- Unity meta files
      custom = { '.\\+.meta' },
   },
})
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

local all_keys = {}
for i = ('a'):byte(), ('z'):byte() do
   table.insert(all_keys, string.char(i))
end
require('which-key').setup {
   triggers_blacklist = {
      i = all_keys,
      t = all_keys,
      c = all_keys,
   }
}

require('guess-indent').setup()
require("symbols-outline").setup()

-- # LSP, snippet, and autocomplete
require("mason").setup()
require 'lsp_signature'.setup {
   hint_prefix = ">> ",
   toggle_key = '<m-k>',
   select_signature_key = '<m-j>'
}
require("luasnip.loaders.from_snipmate").lazy_load()
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
   pattern = { '*.snippets' },
   callback = require("luasnip.loaders.from_snipmate").lazy_load,
})

-- # Eye candy
-- require('incline').setup {
--    window = {
--       margin = {
--          horizontal = 0,
--          vertical = 0
--       }
--    }
-- }
require('colorizer').setup()
require("indent_blankline").setup {
   -- for example, context is off by default, use this to turn it on
   show_current_context = true,
   show_current_context_start = true,
}
require('lualine').setup {
   options = {
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {
         statusline = {},
         winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
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
         function ()
            if require('luasnip').jumpable(1) then
               return '<C-L>'
            end
            return ''
         end,
         function ()
            if require('luasnip').expandable() then
               return 'snip'
            end
            return ''
         end
      },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = { 'filename' },
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
   inactive_sections = {
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
   },
   winbar = {
      lualine_z = { 'filename' }
   },
   tabline = {
   },
   extensions = {}
}
vim.g.catppuccin_flavour = 'mocha' -- latte, frappe, macchiato, mocha
require('catppuccin').setup({
   transparent_background = false,
})
vim.api.nvim_command 'colorscheme catppuccin'

-- # File type specific
require("rust-tools").setup({
   server = {
      on_attach = require('lsp').on_attach
   },
})

require("neodev").setup({
   -- add any options here, or leave empty to use the default settings
})
-- require('go').setup()

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

-- return { setup = setup }
