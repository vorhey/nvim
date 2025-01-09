return {
  'nullromo/go-up.nvim',
  opts = {}, -- specify options here
  config = function(_, opts)
    local goUp = require 'go-up'
    vim.keymap.set({ 'n', 'v' }, '<C-Space>', function()
      require('go-up').align()
    end, { desc = 'align the screen' })
    goUp.setup(opts)
  end,
}
