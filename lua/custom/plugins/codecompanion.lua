return {
  'olimorris/codecompanion.nvim',
  keys = {
    { '<C-b>',      mode = { 'n', 'v' } },
    { '<leader>aa', mode = { 'n', 'v' } },
    { 'ga',         mode = 'v' },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'ravitemer/codecompanion-history.nvim',
    { 'MeanderingProgrammer/render-markdown.nvim', ft = { 'markdown', 'codecompanion' } },
  },
  config = function()
    require('codecompanion').setup {
      extensions = { history = { enabled = true } }
    }
    vim.keymap.set({ 'n', 'v' }, '<C-b>', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true, desc = 'code companion: actions' })
    vim.keymap.set({ 'n', 'v' }, '<leader>aa', '<cmd>CodeCompanionChat Toggle<cr>', { noremap = true, silent = true, desc = 'code companion: toggle' })
    vim.keymap.set('v', 'ga', '<cmd>CodeCompanionChat Add<cr>', { noremap = true, silent = true, desc = 'code companion: chat add' })
    vim.cmd [[cab cc CodeCompanion]]
  end,
}
