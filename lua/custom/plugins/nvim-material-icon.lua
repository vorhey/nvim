return {
  'DaikyXendo/nvim-material-icon',
  lazy = true,
  event = 'VeryLazy', -- Load after initial UI setup
  config = function()
    require('nvim-web-devicons').setup()
  end,
}
