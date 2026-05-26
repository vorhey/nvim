return {
  'tiagovla/scope.nvim',
  enabled = vim.g.neovide == true,
  event = 'VeryLazy',
  config = function()
    vim.opt.sessionoptions:append { 'buffers', 'tabpages', 'globals' }
    require('scope').setup {}
  end,
}
