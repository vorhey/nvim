return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  messages = {
    view_error = 'messages',
    view_warn = 'messages',
  },
  opts = {
    cmdline = {
      view = 'cmdline',
      format = {
        cmdline = { icon = '' },
      },
    },
    views = {
      hover = {
        anchor = 'NE',
        relative = 'editor',
        position = {
          row = 0,
          col = 999,
        },
        size = {
          height = '75%',
          width = '25%',
        },
      },
    },
  },
}
