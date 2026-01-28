return {
  {
    'sainnhe/everforest',
    lazy = false,
    priority = 1000,
    cond = function()
      return vim.g.neovide
    end,
    config = function()
      vim.g.everforest_background = 'hard'
      vim.g.everforest_ui_contrast = 'high'
      vim.g.everforest_float_style = 'blend'
      vim.g.everforest_colors_override = { bg1 = { 'none', 'none' } }
      vim.cmd.colorscheme 'everforest'
      vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'Red', { fg = '#ffdfb8' })
      vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'none' })
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
      vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { bg = 'none' })
    end,
  },
}
