return {
  'echasnovski/mini.notify',
  version = false,
  config = function()
    require('mini.notify').setup {
      window = {
        winblend = 0,
      },
    }
  end,
}
