return {
  'saghen/blink.cmp',
  dependencies = {
    'kristijanhusak/vim-dadbod-completion',
  },
  version = '*',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- See the full "keymap" documentation for information on defining your own keymap.
    keymap = {
      preset = 'super-tab',
      ['<C-h>'] = {
        function(cmp)
          cmp.snippet_backward()
        end,
      },
      ['<C-l>'] = {
        function(cmp)
          cmp.snippet_forward()
        end,
      },
      ['<C-d>'] = {
        'show',
        'show_documentation',
        'hide_documentation',
      },
    },
    cmdline = {
      enabled = false,
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono',
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'lazydev' },
      per_filetype = {
        sql = { 'snippets', 'dadbod', 'buffer' },
      },
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          -- make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
        dadbod = {
          name = 'Dadbod',
          module = 'vim_dadbod_completion.blink',
          transform_items = function(self, items)
            for _, item in ipairs(items) do
              if item.label then
                item.label = string.lower(item.label)
              end
              if item.insertText then
                item.insertText = string.lower(item.insertText)
              end
            end
            return items
          end,
        },
      },
    },
    completion = {
      trigger = {
        show_on_insert_on_trigger_character = false,
      },
      documentation = {
        auto_show_delay_ms = 200,
        window = { border = 'rounded' },
      },
      menu = {
        scrollbar = false,
        border = 'rounded',
        draw = {
          components = {
            kind_icon = {
              ellipsis = false,
              text = function(ctx)
                local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                return kind_icon
              end,
              -- Optionally, you may also use the highlights from mini.icons
              highlight = function(ctx)
                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                return hl
              end,
            },
          },
          treesitter = { 'lsp' },
        },
      },
    },
  },
  opts_extend = { 'sources.default' },
}
