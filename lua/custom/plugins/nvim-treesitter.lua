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
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = { query = '@function.outer', desc = 'select around function' },
            ['if'] = { query = '@function.inner', desc = 'select inner function' },
            ['ac'] = { query = '@class.outer', desc = 'select around class' },
            ['ic'] = { query = '@class.inner', desc = 'select inner part of a class region' },
            ['as'] = { query = '@local.scope', query_group = 'locals', desc = 'select language scope' },
            ['ia'] = { query = '@parameter.inner', desc = 'select inner parameter' },
            ['aa'] = { query = '@parameter.outer', desc = 'select around parameter (with commas)' },
          },
        },
      }

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
          'jsonc',
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
          enable = false,
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
