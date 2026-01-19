return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    cond = function()
      return vim.g.neovide
    end,
    config = function()
      require('catppuccin').setup {}
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
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
    end,
  },
}
