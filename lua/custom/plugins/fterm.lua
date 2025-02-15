local utils = require 'utils'
return {
  'numToStr/FTerm.nvim',
  opts = {
    border = 'rounded',
    cmd = utils.is_wsl() and 'zsh' or 'pwsh',
  },
  config = function(_, opts)
    require('FTerm').setup(opts)
    vim.keymap.set('n', '<c-t>', '<CMD>lua require("FTerm").toggle()<CR>')
    vim.keymap.set('t', '<c-t>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
  end,
}
