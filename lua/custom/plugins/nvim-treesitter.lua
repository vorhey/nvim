return {
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
      },
      {
        'MeanderingProgrammer/treesitter-modules.nvim',
      },
    },
    branch = 'main',
    lazy = false,
    version = false,
    build = ':TSUpdate',
    opts = {
      install_dir = vim.fn.stdpath 'data' .. '/site',
    },
    config = function(_, opts)
      -- Setup nvim-treesitter
      require('nvim-treesitter').setup(opts)
      -- Setup textobjects using the correct module
      require('nvim-treesitter-textobjects').setup {
        select = {
          lookahead = true,
          selection_modes = {
            ['@parameter.inner'] = 'v',
            ['@parameter.outer'] = 'v',
          },
        },
      }
      local select = require 'nvim-treesitter-textobjects.select'

      for _, mode in ipairs { 'x', 'o' } do
        vim.keymap.set(mode, 'i,', function()
          select.select_textobject('@parameter.inner', 'textobjects')
        end, { desc = 'TS inner parameter' })

        vim.keymap.set(mode, 'a,', function()
          select.select_textobject('@parameter.outer', 'textobjects')
        end, { desc = 'TS around parameter (incl. comma/space)' })
      end

      require('treesitter-modules').setup {
        ensure_installed = {
          'bash',
          'c',
          'c_sharp',
          'cpp',
          'css',
          'dart',
          'diff',
          'dockerfile',
          'go',
          'gomod',
          'graphql',
          'haskell',
          'hcl',
          'html',
          'java',
          'javascript',
          'jsdoc',
          'json',
          'kotlin',
          'lua',
          'luadoc',
          'luap',
          'markdown',
          'markdown_inline',
          'php',
          'prisma',
          'printf',
          'python',
          'query',
          'regex',
          'ruby',
          'rust',
          'scala',
          'scss',
          'sql',
          'svelte',
          'swift',
          'terraform',
          'toml',
          'tsx',
          'tmux',
          'typescript',
          'vim',
          'vimdoc',
          'vue',
          'xml',
          'yaml',
          'zig',
        },
        auto_install = false,
        fold = {
          enable = true,
        },
        highlight = {
          enable = true, -- keep TS highlighter active so render-markdown can reuse it
        },
        indent = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            node_incremental = 'v',
            node_decremental = 'V',
          },
        },
      }
    end,
  },
}
