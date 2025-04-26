return {
  'chrisgrieser/nvim-tinygit',
  tag = 'v0.9',
  dependencies = 'stevearc/dressing.nvim',
  config = function()
    require('tinygit').setup {}
    vim.keymap.set('v', '<leader>gh', function()
      require('tinygit').fileHistory()
    end, { desc = 'git file history' })
  end,
}
