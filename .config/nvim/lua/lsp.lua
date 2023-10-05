local on_attach = function(client, bufnr)
    -- vim.api.nvim_create_autocmd('CursorHold', { callback = function(_) vim.lsp.buf.hover() end })
    require'keymaps'.on_attach_keymaps(bufnr)
end

---- Copied from :h lspconfig-keybindings
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

vim.keymap.set('n', '<space>l<space>', vim.diagnostic.open_float, opts)
vim.keymap.set('i', '<a-k>', vim.lsp.buf.signature_help, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer

---- :h cmp-usage
local cmp = require 'cmp'
local luasnip = require("luasnip")

vim.keymap.set({ 'i', 's' }, '<c-l>', function() luasnip.jump(1) end)
vim.keymap.set({ 'i', 's' }, '<c-h>', function() luasnip.jump(-1) end)
-- vim.keymap.set({'i', 's'}, '<tab>', function() luasnip.jump(1) end)
vim.keymap.set({ 'i', 's' }, '<s-tab>', function() luasnip.jump(-1) end)

-- Global setup.
cmp.setup({
   snippet = {
      expand = function(args)
         require('luasnip').lsp_expand(args.body)
      end,
   },
   window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
   },
   -- mapping = cmp.mapping.preset.insert({
   mapping = {
      ['<Down>'] = {
         i = cmp.mapping.select_next_item({ behavior = 'select' }),
      },
      ['<Up>'] = {
         i = cmp.mapping.select_prev_item({ behavior = 'select' }),
      },

      -- require('cmp.types').cmp.SelectBehavior.Select
      ['<c-n>'] = cmp.mapping.select_next_item(),
      ['<c-p>'] = cmp.mapping.select_prev_item(),

      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping(function(fallback)
         if not cmp.visible() then
            cmp.complete()
         else
            cmp.close()
         end
      end),
      ['<CR>'] = cmp.mapping.confirm({ select = false }),
      ["<Tab>"] = cmp.mapping(function(fallback)
         if luasnip.expandable() then
            luasnip.expand({})
         elseif cmp.visible() then
            cmp.confirm({ select = true })
         elseif luasnip.jumpable(1) then
            luasnip.jump(1)
         else
            fallback()
         end
      end, { "i", "s" }),

      -- ["<S-Tab>"] = cmp.mapping(function(fallback)
      --   if cmp.visible() then
      --     cmp.select_prev_item()
      --   elseif luasnip.jumpable(-1) then
      --     luasnip.jump(-1)
      --   else
      --     fallback()
      --   end
      -- end, { "i", "s" }),
   },

   completion = {
      keyword_length = 2,
   },

   sources = cmp.config.sources({
      { name = 'luasnip' },
      { name = 'nvim_lsp' },
      -- { name = 'nvim_lsp_signature_help' },
   }, {
      { name = 'buffer' },
   })
})

-- `/ cmdline setup.
cmp.setup.cmdline('/', {
   mapping = cmp.mapping.preset.cmdline(),
   sources = {
      { name = 'buffer' }
   }
})

-- `:` cmdline setup.
cmp.setup.cmdline(':', {
   mapping = cmp.mapping.preset.cmdline(),
   sources = cmp.config.sources({
      { name = 'path' }
   }, {
      { name = 'cmdline' }
   })
})

return {
   on_attach = on_attach
}
