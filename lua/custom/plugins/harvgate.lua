return {
  'vorhey/harvgate',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('harvgate').setup {
      width = 70,
      height = 10,
    }
    vim.keymap.set('n', '<leader>hh', ':HarvgateChat<CR>', { desc = 'harvgate toggle chat' })
    vim.keymap.set('n', '<leader>hc', ':HarvgateListChats<CR>', { desc = 'harvgate open chats' })
    vim.keymap.set('n', '<leader>ha', ':HarvgateAddBuffer<CR>', { desc = 'harvgate add buffer' })
  end,
}
