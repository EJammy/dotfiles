local options = {
   number = true,
   -- relativenumber = true,

   tabstop = 4,
   shiftwidth = 0, -- use value from tabstop
   smarttab = true,
   ignorecase = true,

   expandtab = true,

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
   breakindent = true,

   scrolloff = 4,
   undofile = true,

   smartcase = true,

   -- for nvim cmp?
   -- completeopt = 'menu,menuone,noselect',

   -- fix colors
   termguicolors = true,

   -- fold method
   foldmethod = 'syntax',

   exrc = true
}

for key, val in pairs(options) do
   vim.opt[key] = val
end

