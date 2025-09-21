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
    { 'hrsh7th/cmp-nvim-lsp-signature-help', event = 'InsertEnter' },
    { 'onsails/lspkind.nvim', event = 'InsertEnter' },
    { 'vorhey/nvim-html-css', opts = { enable_on = { 'html', 'jsx', 'tsx' } } },
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
      { name = 'lazydev' },
      { name = 'luasnip' },
      { name = 'path' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'html-css' },
    }

    local formatting = {
      fields = { 'kind', 'abbr', 'menu' },
      format = function(entry, item)
        item.dup = 0
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
      sorting = {
        priority_weight = 2,
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.recently_used,
          require 'clangd_extensions.cmp_scores',
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
      formatting = formatting,
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      view = {
        docs = {
          auto_open = false,
        },
      },
      completion = {
        keyword_length = 2,
      },
      performance = {
        debounce = 100,
        throttle = 50,
        fetching_timeout = 500,
        confirm_resolve_timeout = 80,
        async_budget = 1,
        max_view_entries = 5,
        filtering_context_budget = 3, -- Lines of context for filtering
      },
    }
  end,
}
