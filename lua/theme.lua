return {
  {
    'vorhey/ember.nvim',
    lazy = false,
    cond = function()
      return vim.env.TERM_COLOR == 'dark'
    end,
    config = function()
      vim.cmd.colorscheme 'ember'
    end,
  },
  {
    'vorhey/oldworld.nvim',
    lazy = false,
    cond = function()
      return vim.env.TERM_COLOR == 'light'
    end,
    config = function()
      require('oldworld').setup {
        variant = 'light',
      }
      vim.cmd.colorscheme 'oldworld'
      vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { bg = 'none' })
    end,
  },
}
