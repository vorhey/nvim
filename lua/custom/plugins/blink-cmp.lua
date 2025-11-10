return {
  'saghen/blink.cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  enabled = true,
  dependencies = {
    'onsails/lspkind.nvim',
    'rcarriga/cmp-dap',
    'rafamadriz/friendly-snippets',
    { 'L3MON4D3/LuaSnip', version = 'v2.*' },
    {
      'saghen/blink.compat',
      opts = {},
      version = '*',
    },
  },
  version = '*',
  config = function()
    require('luasnip.loaders.from_vscode').lazy_load()
    require('luasnip.loaders.from_vscode').lazy_load {
      paths = {
        vim.fn.stdpath 'config' .. '/snippets',
      },
    }
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
        default = { 'lsp', 'path', 'snippets' },
        per_filetype = {
          ['dap-repl'] = { 'dap' },
          dapui_watches = { 'dap' },
          dapui_hover = { 'dap' },
        },
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
          dap = {
            name = 'dap',
            module = 'blink.compat.source',
            opts = {
              name = 'dap',
            },
          },
        },
      },
      snippets = { preset = 'luasnip' },
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
