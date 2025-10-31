return {
  'XXiaoA/atone.nvim',
  config = function()
    require('atone').setup {}
    vim.keymap.set('n', '<leader>u', '<cmd>Atone toggle<cr>', { desc = 'Atone' })
  end,
}
