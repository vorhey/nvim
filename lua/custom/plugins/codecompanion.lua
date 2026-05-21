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
    {
      '<leader>ac',
      ':CodeCompanionChat Toggle<CR>',
      desc = 'codecompanion: toggle chat',
      noremap = true,
      silent = true,
    },
    {
      '<leader>aa',
      ':CodeCompanionActions<CR>',
      desc = 'codecompanion: actions',
      noremap = true,
      silent = true,
    },
    {
      '<leader>an',
      ':CodeCompanionChat<CR>',
      desc = 'codecompanion: new chat',
      noremap = true,
      silent = true,
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
}
