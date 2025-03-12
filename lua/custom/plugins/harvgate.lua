return {
  'vorhey/harvgate',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('harvgate').setup {
      width = 70,
    }
    vim.keymap.set('n', '<leader>a', ':HarvgateChat<CR>', { desc = 'harvgate' })
    vim.keymap.set('n', '<leader>A', ':HarvgateListChats<CR>', { desc = 'harvgate chat list' })
  end,
}
