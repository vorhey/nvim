return {
  {
    'vorhey/ember.nvim',
    lazy = false,
    cond = function()
      return vim.env.TERM_COLOR == 'dark' or vim.g.neovide
    end,
    config = function()
      vim.cmd.colorscheme 'ember'
      if vim.g.neovide then
        vim.api.nvim_set_hl(0, 'Normal', { bg = '#211f24' })
      end
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
