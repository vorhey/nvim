return {
  'nvim-mini/mini.files',
  lazy = false,
  keys = {
    {
      '<leader>e',
      function()
        require('mini.files').open()
      end,
      desc = 'explorer',
    },
  },
}
