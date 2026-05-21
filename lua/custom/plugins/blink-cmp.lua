return {
  'saghen/blink.cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  enabled = true,
  dependencies = {
    'rcarriga/cmp-dap',
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
        preset = 'super-tab',
        ['<Tab>'] = {
          require('blink.cmp.keymap.presets').get('super-tab')['<Tab>'][1],
          function(cmp)
            if cmp.snippet_forward() then return true end
            if require('sidekick').nes_jump_or_apply() then return true end
          end,
          'fallback',
        },
        ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        ['<C-d>'] = { 'show_documentation', 'hide_documentation' },
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
          auto_show = false,
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
          lua = { 'lsp', 'path', 'snippets', 'lazydev' },
          html = { 'lsp', 'path', 'snippets', 'html-css' },
          htmldjango = { 'lsp', 'path', 'snippets', 'html-css' },
          jsx = { 'lsp', 'path', 'snippets', 'html-css' },
          tsx = { 'lsp', 'path', 'snippets', 'html-css' },
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
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
          ['html-css'] = {
            name = 'HTML-CSS',
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
