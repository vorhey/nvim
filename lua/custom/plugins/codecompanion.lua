return {
  'olimorris/codecompanion.nvim',
  version = '^19.0.0',
  opts = {},
  keys = {
    {
      '<leader>ae',
      ':CodeCompanion<CR>',
      mode = 'x',
      desc = 'codecompanion: prompt',
      noremap = true,
      silent = true,
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
}
