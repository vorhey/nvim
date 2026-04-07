return {
  {
    'vorhey/oldworld.nvim',
    lazy = false,
    priority = 1000,
    cond = function()
      return not vim.g.neovide
    end,
    config = function()
      local variant = 'light'
      if vim.env.TERM == 'foot' or vim.env.TERM_COLOR == 'dark' then
        variant = 'dark'
      end
      require('oldworld').setup {
        variant = variant,
      }
      vim.cmd.colorscheme 'oldworld'
      vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { bg = 'none' })
    end,
  },
}
