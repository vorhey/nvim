return {
  'nvim-mini/mini.splitjoin',
  event = 'VeryLazy',
  version = false,
  config = function()
    require('mini.splitjoin').setup {}
  end,
}
