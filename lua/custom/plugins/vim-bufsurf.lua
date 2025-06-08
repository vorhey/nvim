return {
  'ton/vim-bufsurf',
  config = function()
    vim.keymap.set('n', '[b', '<Plug>(buf-surf-back)', { desc = 'Previous buffer' })
    vim.keymap.set('n', ']b', '<Plug>(buf-surf-forward)', { desc = 'Next buffer' })
  end,
}
