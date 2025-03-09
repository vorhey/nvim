return {
  'Hashino/doing.nvim',
  lazy = true,
  init = function()
    local doing = require 'doing'
    vim.keymap.set('n', '<leader>0a', doing.add, { desc = 'add' })
    vim.keymap.set('n', '<leader>00', doing.edit, { desc = 'edit' })
  end,
}
