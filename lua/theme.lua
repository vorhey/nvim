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
      require('catppuccin').setup {
        transparent_background = false, -- disables setting the background color.
        float = {
          transparent = true, -- enable transparent floating windows
          solid = true, -- use solid styling for floating windows, see |winborder|
        },
      }
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
