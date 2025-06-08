return {
  'stevearc/oil.nvim',
  config = function()
    ---@type oil.SetupOpts
    require('oil').setup {
      float = {
        padding = 0,
        max_height = 0.99,
      },
    }
    vim.keymap.set('n', '<leader>e', function()
      require('oil').open_float()
    end, { desc = 'explorer' })
  end,
  -- Optional dependencies
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  lazy = false,
}
