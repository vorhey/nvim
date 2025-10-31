return {
  'saghen/blink.cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  enabled = true,
  dependencies = {
    'onsails/lspkind.nvim',
    {
      'saghen/blink.compat',
      opts = {},
      version = '*',
    },
  },
  version = '*',
  config = function()
    require('blink.cmp').setup {
      keymap = {
        preset = 'default',
        ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        -- Use built-in show/hide documentation commands instead of custom function
        ['<C-d>'] = { 'show_documentation', 'hide_documentation' },
        ['<Tab>'] = { 'select_and_accept', 'snippet_forward', 'fallback' },
        -- Snippet navigation (equivalent to your C-h/C-l)
        ['<C-h>'] = { 'snippet_backward', 'fallback' },
        ['<C-l>'] = { 'snippet_forward', 'fallback' },
      },

      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
            blocked_filetypes = { 'cs' },
          },
        },
        trigger = {
          prefetch_on_insert = true,
          show_on_insert_on_trigger_character = true,
        },
        list = {
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },
        menu = {
          scrollbar = false,
          border = 'rounded',
          draw = {
            treesitter = { 'lsp' },
            columns = {
              { 'kind_icon' },
              { 'label', 'label_description', gap = 1 },
            },
          },
        },
        documentation = {
          auto_show = false, -- Matches your auto_open = false
          auto_show_delay_ms = 500,
          treesitter_highlighting = true,
          window = {
            border = 'rounded',
          },
        },
      },
      signature = {
        enabled = false,
      },
      sources = {
        default = { 'lsp', 'path' },
        providers = {
          lsp = {
            name = 'LSP',
            module = 'blink.cmp.sources.lsp',
          },
          path = {
            name = 'Path',
            module = 'blink.cmp.sources.path',
            score_offset = -3,
          },
          -- Using compat layer for html-css
          ['html-css'] = {
            name = 'HTML-CSS',
            module = 'blink.compat.source',
            opts = {
              enable_on = { 'html', 'jsx', 'tsx' },
            },
          },
          -- Using compat layer for lazydev
          lazydev = {
            name = 'LazyDev',
            module = 'blink.compat.source',
          },
        },
      },

      snippets = {
        expand = function(snippet)
          vim.snippet.expand(snippet)
        end,
        active = function(filter)
          if filter and filter.direction then
            return vim.snippet.active { direction = filter.direction }
          end
          return vim.snippet.active()
        end,
        jump = function(direction)
          vim.snippet.jump(direction)
        end,
      },

      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = 'mono',
      },

      fuzzy = {
        prebuilt_binaries = {
          download = true,
          force_version = nil,
        },
      },
    }
  end,
}
