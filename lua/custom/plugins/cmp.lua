return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    {
      'L3MON4D3/LuaSnip',
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        --    See the README about individual language/framework/plugin snippets:
        --    https://github.com/rafamadriz/friendly-snippets
        {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
          end,
        },
      },
    },
    {
      'Exafunction/codeium.nvim',
      enabled = true,
      dependencies = {
        'nvim-lua/plenary.nvim',
        'hrsh7th/nvim-cmp',
      },
      opts = {},
    },
    'saadparwaiz1/cmp_luasnip',
    -- Adds other completion capabilities.
    --  nvim-cmp does not ship with all sources by default. They are split
    --  into multiple repos for maintenance purposes.
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    -- lsp icons
    'onsails/lspkind.nvim',
  },
  config = function()
    -- See `:help cmp`
    require('codeium').setup {}
    local cmp = require 'cmp'
    local utils = require 'utils'
    -- Register sources
    local sources = {
      { name = 'codeium', max_item_count = 3 },
      { name = 'nvim_lsp', max_item_count = 10 },
      { name = 'luasnip' },
      { name = 'path' },
    }
    -- Pass sources to utils setup for additional resources configuration
    utils.setup_cmp_sources(sources)
    local ls = require 'luasnip'
    cmp.setup {
      ---@diagnostic disable-next-line: missing-fields
      formatting = {
        format = function(entry, vim_item)
          local lspkind = require 'lspkind'

          vim.cmd [[ 
            highlight CustomCmpCodeium guifg=#E0AF68
            
          ]]

          local menus = {
            buffer = '[buf]',
            codeium = '[Codeium]',
            nvim_lsp = '[LSP]',
            path = '[path]',
            luasnip = '[snip]',
            nvim_lua = '[lua]',
          }

          vim_item.menu = menus[entry.source.name] or ''

          local symbol_map = {
            Codeium = '󰑴',
          }

          vim_item.kind = lspkind.symbolic(vim_item.kind, { mode = 'symbol_text' })

          if entry.source.name == 'codeium' then
            vim_item.kind = symbol_map['Codeium']
            vim_item.kind = vim_item.kind .. ' ML'
            vim_item.kind_hl_group = 'CustomCmpCodeium'
          end

          vim_item.kind = vim_item.kind .. ' ' .. vim_item.menu

          return vim_item
        end,
      },
      snippet = {
        expand = function(args)
          ls.lsp_expand(args.body)
        end,
      },
      preselect = 'None',
      completion = { completeopt = 'menu,menuone,noselect,noinsert' },
      -- For an understanding of why these mappings were
      -- chosen, you will need to read `:help ins-completion`
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      mapping = cmp.mapping.preset.insert {
        -- Select the [n]ext item
        ['<C-n>'] = cmp.mapping.select_next_item(),
        -- Select the [p]revious item
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        -- Scroll the documentation window [b]ack / [f]orward
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        -- Accept ([y]es) the completion.
        --  This will auto-import if your LSP supports it.
        --  This will expand snippets if the LSP sent a snippet.
        ['<C-y>'] = cmp.mapping.confirm { select = true },
        -- Manually trigger a completion from nvim-cmp.
        --  Generally you don't need this, because nvim-cmp will display
        --  completions whenever it has completion options available.
        ['<C-Space>'] = cmp.mapping.complete {},
        -- Think of <c-l> as moving to the right of your snippet expansion.
        --  So if you have a snippet that's like:
        --  function $name($args)
        --    $body
        --  end
        --
        -- <c-l> will move you to the right of each of the expansion locations.
        -- <c-h> is similar, except moving you backwards.
        ['<C-l>'] = cmp.mapping(function()
          if ls.expand_or_locally_jumpable() then
            ls.expand_or_jump()
          end
        end, { 'i', 's' }),
        ['<C-h>'] = cmp.mapping(function()
          if ls.locally_jumpable(-1) then
            ls.jump(-1)
          end
        end, { 'i', 's' }),
        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps

        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif require('luasnip').expand_or_jumpable() then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif require('luasnip').jumpable(-1) then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      sources = cmp.config.sources(sources),
    }
  end,
}
