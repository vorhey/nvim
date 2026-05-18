return {
  'nvim-mini/mini-git',
  version = false,
  keys = {
    {
      '<leader>gh',
      function()
        require('mini.git').show_range_history()
      end,
      desc = 'Git range history',
      mode = 'v',
    },
    {
      '<leader>gd',
      function()
        require('mini.git').show_at_cursor()
      end,
      desc = 'Git show at cursor',
      mode = 'n',
    },
  },
}
