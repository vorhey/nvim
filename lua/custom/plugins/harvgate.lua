return {
  'vorhey/harvgate',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
  },
  config = function()
    vim.keymap.set('n', '<leader>a', ':HarvgateChat<CR>', { desc = 'Harvgate Chat', noremap = true, silent = true })
    require('harvgate').setup {
      model = 'claude-3-5-haiku-20241022',
    }
  end,
}
