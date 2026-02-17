return {
  'hrsh7th/nvim-cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  enabled = function()
    return vim.g.neovide == true
  end,
  dependencies = {
    { 'hrsh7th/cmp-nvim-lsp', event = 'InsertEnter' },
    { 'hrsh7th/cmp-buffer', event = 'InsertEnter' },
    { 'hrsh7th/cmp-path', event = 'InsertEnter' },
    { 'hrsh7th/cmp-nvim-lsp-signature-help', event = 'InsertEnter' },
    { 'onsails/lspkind.nvim', event = 'InsertEnter' },
  },
  config = function()
    vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

    local cmp = require 'cmp'

    local docs_enabled = false

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

    local keybinds = {
      ['<C-Space>'] = cmp.mapping.complete {},
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-d>'] = cmp.mapping(toggle_docs),

      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.confirm { select = true }
        else
          fallback()
        end
      end, { 'i', 's' }),

      ['<C-h>'] = cmp.mapping(function(fallback)
        if vim.snippet.active { direction = -1 } then
          vim.snippet.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),

      ['<C-l>'] = cmp.mapping(function(fallback)
        if vim.snippet.active { direction = 1 } then
          vim.snippet.jump(1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    }

    local sources = cmp.config.sources {
      { name = 'nvim_lsp' },
      { name = 'lazydev' },
      { name = 'path' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'html-css' },
    }

    local formatting = {
      fields = { 'kind', 'abbr', 'menu' },
      format = function(entry, item)
        if entry.source.name == 'path' then
          item.dup = 0
        end

        local kind = require('lspkind').cmp_format {
          mode = 'symbol_text',
          maxwidth = 50,
          ellipsis_char = '...',
        }(entry, item)
        local strings = vim.split(kind.kind, '%s', { trimempty = true })
        kind.kind = ' ' .. (strings[1] or '') .. ' '
        kind.menu = '    (' .. (strings[2] or '') .. ') [' .. entry.source.name .. ']'
        return kind
      end,
    }

    cmp.setup {
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
        filtering_context_budget = 3,
      },
    }
  end,
}
