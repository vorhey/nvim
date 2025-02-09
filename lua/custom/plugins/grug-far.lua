return {
  'MagicDuck/grug-far.nvim',
  config = function()
    require('grug-far').setup {
      -- options, see Configuration section below
      -- there are no required options atm
      -- engine = 'ripgrep' is default, but 'astgrep' can be specified
    }
    vim.keymap.set('n', '<c-h>', function()
      require('grug-far').open {
        prefills = {
          paths = vim.fn.expand '%',
        },
      }
    end, { desc = 'replace (file)' })
  end,
}
