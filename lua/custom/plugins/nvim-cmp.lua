return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  enabled = true,
  dependencies = {
    -- luasnip
    {
      'L3MON4D3/LuaSnip',
      version = 'v2.*',
      dependencies = {
        'saadparwaiz1/cmp_luasnip',
        'rafamadriz/friendly-snippets',
      },
      build = 'make install_jsregexp',
    },
    { 'hrsh7th/cmp-nvim-lsp', event = 'InsertEnter' },
    { 'hrsh7th/cmp-buffer', event = 'InsertEnter' },
    { 'hrsh7th/cmp-path', event = 'InsertEnter' },
    { 'hrsh7th/cmp-cmdline', event = 'CmdlineEnter' },
    { 'hrsh7th/cmp-nvim-lsp-signature-help', event = 'InsertEnter' },
    { 'onsails/lspkind.nvim', event = 'InsertEnter' },
  },
  config = function()
    -- Set vim options that cmp expects
    vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

    local cmp = require 'cmp'
    local luasnip = require 'luasnip'

    -- Load snippets
    require('luasnip.loaders.from_vscode').lazy_load()

    luasnip.filetype_extend('javascript', { 'jsdoc' })
    luasnip.filetype_extend('typescript', { 'jsdoc' })

    luasnip.config.setup { enable_autosnippets = true }

    -- Variable to track documentation window state
    local docs_enabled = false

    -- Function to toggle documentation
    local function toggle_docs()
      docs_enabled = not docs_enabled
      if docs_enabled then
        if cmp.visible() then
          cmp.open_docs()
        end
      else
        cmp.close_docs()
      end
    end

    -- Keymaps
    local keybinds = {
      ['<C-Space>'] = cmp.mapping.complete {},
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-d>'] = cmp.mapping(toggle_docs), -- Toggle documentation

      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.confirm { select = true }
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),

      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),

      ['<C-h>'] = cmp.mapping(function()
        if luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { 'i', 's' }),

      ['<C-l>'] = cmp.mapping(function()
        if luasnip.locally_jumpable(1) then
          luasnip.jump(1)
        end
      end, { 'i', 's' }),
    }

    local sources = cmp.config.sources {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'path' },
      { name = 'nvim_lsp_signature_help' },
    }

    local formatting = {
      fields = { 'kind', 'abbr', 'menu' },
      format = function(entry, item)
        local kind = require('lspkind').cmp_format {
          mode = 'symbol_text',
          maxwidth = 50,
          ellipsis_char = '...',
        }(entry, item)
        local strings = vim.split(kind.kind, '%s', { trimempty = true })
        kind.kind = ' ' .. (strings[1] or '') .. ' '
        kind.menu = '    (' .. (strings[2] or '') .. ')'
        return kind
      end,
    }

    -- Main setup
    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert(keybinds),
      sources = sources,
      formatting = formatting,
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      -- Disable automatic documentation
      view = {
        docs = {
          auto_open = true,
        },
      },
    }

    -- Cmdline setup for search
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' },
      },
    })

    -- Cmdline setup for commands
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        { name = 'cmdline' },
      }),
      matching = { disallow_symbol_nonprefix_matching = false },
    })
  end,
}
