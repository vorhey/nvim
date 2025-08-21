return {
  'vorhey/harvgate',
  lazy = true,
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('harvgate').setup {
      width = 70,
      height = 10,
      model = 'claude-opus-4-1-20250805',
    }
    vim.keymap.set('n', '<leader>hh', ':HarvgateChat<CR>', { desc = 'harvgate toggle chat', silent = true })
    vim.keymap.set('n', '<leader>hc', ':HarvgateListChats<CR>', { desc = 'harvgate open chats', silent = true })
    vim.keymap.set('n', '<leader>ha', ':HarvgateAddBuffer<CR>', { desc = 'harvgate add buffer', silent = true })
  end,
}
