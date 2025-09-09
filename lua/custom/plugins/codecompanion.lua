return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    {
      'MeanderingProgrammer/render-markdown.nvim',
      ft = { 'markdown', 'codecompanion' },
    },
  },
  config = function()
    require('codecompanion').setup {}
    vim.keymap.set({ 'n', 'v' }, '<C-b>', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true, desc = 'code companion actions' })
    vim.keymap.set({ 'n', 'v' }, '<leader>ch', '<cmd>CodeCompanionChat Toggle<cr>', { noremap = true, silent = true, desc = 'code companion chat' })
    vim.keymap.set('v', 'ga', '<cmd>CodeCompanionChat Add<cr>', { noremap = true, silent = true, desc = 'code companion chat add' })
    -- Expand 'cc' into 'CodeCompanion' in the command line
    vim.cmd [[cab cc CodeCompanion]]
  end,
}
