return {
  {
    'scottmckendry/cyberdream.nvim',
    lazy = false,
    priority = 1000,
    cond = function()
      return vim.g.neovide
    end,
    config = function()
      vim.cmd.colorscheme 'cyberdream'
      vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'Float', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'Keyword', { fg = '#8FA6FF' })
      vim.api.nvim_set_hl(0, 'Number', { fg = '#8FFFF8' })
      vim.api.nvim_set_hl(0, 'Operator', { fg = '#FFBDE1' })
      vim.api.nvim_set_hl(0, 'SnacksPicker', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'SnacksPickerBorder', { bg = 'none' })
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
