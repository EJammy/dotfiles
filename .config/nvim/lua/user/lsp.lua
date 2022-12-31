local function setup()
  ---- Copied from :h lspconfig-keybindings
  -- Mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  local opts = { noremap=true, silent=true }
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

  vim.keymap.set('n', '<space>l<space>', vim.diagnostic.open_float, opts)

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  ---@diagnostic disable-next-line: unused-local
  local on_attach = function(client, bufnr)
      --- Guard against servers without the signatureHelper capability
      if client.server_capabilities.signatureHelpProvider then
          require('lsp-overloads').setup(client, { })
      end

      -- Enable completion triggered by <c-x><c-o>
      -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

      -- Mappings.
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      local bufopts = { noremap=true, silent=true, buffer=bufnr }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)

      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)

      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
      vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, bufopts)
      vim.keymap.set('n', '<space>la', vim.lsp.buf.add_workspace_folder, bufopts)
      vim.keymap.set('n', '<space>lr', vim.lsp.buf.remove_workspace_folder, bufopts)
      vim.keymap.set('n', '<space>ll', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, bufopts)

      vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
      vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
      vim.keymap.set('n', '<f2>', vim.lsp.buf.rename, bufopts)

      vim.keymap.set('n', '<space>lc', vim.lsp.buf.code_action, bufopts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
      vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
  end

  ---- :h cmp-usage
  local cmp = require'cmp'
  local luasnip = require("luasnip")

  vim.keymap.set({'i', 's'}, '<c-l>', function() luasnip.jump(1) end)
  vim.keymap.set({'i', 's'}, '<c-h>', function() luasnip.jump(-1) end)

  -- Global setup.
  cmp.setup({
    snippet = {
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
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
              cmp.confirm({ select = true })
          end
      end),
      ['<CR>'] = cmp.mapping.confirm({ select = false }),
      ["<Tab>"] = cmp.mapping(function(fallback)
          if luasnip.expandable() then
              luasnip.expand({})
          elseif cmp.visible() then
              cmp.confirm({ select = true })
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

  return { on_attach = on_attach }
end

return { setup = setup }
