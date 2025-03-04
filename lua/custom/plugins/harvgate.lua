return {
  'vorhey/harvgate',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('harvgate').setup {}
    vim.keymap.set('n', '<leader>a', ':HarvgateChat<CR>', { desc = 'harvgate' })
  end,
}
