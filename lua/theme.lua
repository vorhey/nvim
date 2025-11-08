return {
  enabled = true,
  'vorhey/oldworld.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('oldworld').setup {}
    vim.cmd.colorscheme 'oldworld'
  end,
}
