return {
  'kevinhwang91/nvim-fundo',
  dependencies = {
    'kevinhwang91/promise-async',
  },
  run = function()
    require('fundo').install()
  end,
  config = function()
    vim.o.undofile = true
    require('fundo').setup()
  end,
}
