return {
  'echasnovski/mini.notify',
  version = false,
  config = function()
    require('mini.notify').setup {
      window = {
        winblend = 0,
      },
      lsp_progress = {
        enable = false,
      },
    }
  end,
}
