return {
  'XXiaoA/atone.nvim',
  cmd = 'Atone',
  config = function()
    require('atone').setup {}
    vim.keymap.set('n', '<leader>u', '<cmd>Atone<cr>', { desc = 'Atone' })
  end,
}
