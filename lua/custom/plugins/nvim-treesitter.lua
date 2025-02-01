return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  dependencies = {
    'RRethy/nvim-treesitter-endwise',
  },
  opts = {
    ensure_installed = {
      'bash',
      'c',
      'css',
      'html',
      'lua',
      'markdown',
      'markdown_inline',
      'vim',
      'vimdoc',
      'javascript',
      'typescript',
      'go',
      'tsx',
      'xml',
      'dart',
    },
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      disable = { 'sh', 'bash' },
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        node_incremental = 'v',
        node_decremental = 'V',
      },
    },
    indent = {
      enable = true,
      disable = { 'lua' },
    },
    endwise = {
      enable = true,
    },
  },
  config = function(_, opts)
    ---@diagnostic disable-next-line: missing-fields
    require('nvim-treesitter.configs').setup(opts)
  end,
}
