return {
  'nvim-mini/mini.move',
  event = 'VeryLazy',
  version = false,
  config = function()
    require('mini.move').setup {
      mappings = {
        left = '',
        right = '',
        line_left = '',
        line_right = '',
      },
    }
  end,
}
