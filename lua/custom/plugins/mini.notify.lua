return {
  'echasnovski/mini.notify',
  version = false,
  config = function()
    require('mini.notify').setup {
      content = {
        format = function(notify)
          return notify.msg
        end,
      },
      window = {
        winblend = 0,
      },
    }
  end,
}
