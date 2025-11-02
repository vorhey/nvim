return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
  lazy = false,
  keys = {
    {
      '<leader>e',
      function()
        require('oil').open()
      end,
      desc = 'explorer',
    },
  },
}
