return {
  'ton/vim-bufsurf',
  config = function()
    vim.keymap.set('n', '[[', ':BufSurfBack<CR>', { silent = true, desc = 'Go back' })
    vim.keymap.set('n', ']]', ':BufSurfForward<CR>', { silent = true, desc = 'Go back' })
  end,
}
