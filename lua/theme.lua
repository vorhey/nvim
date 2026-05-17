return {
  {
    cond = function()
      return vim.g.neovide
    end,
    'daedlock/matugen.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('matugen').setup {
        colors_path = '~/.config/matugen/colors-empty.json',
        contrast = 0.08,
        -- min_contrast = 0.1,
        brightness = -0.02,
        -- sidebar_brightness = -0.04,
      }
      vim.cmd.colorscheme 'matugen'

      local function transparent_statusline()
        vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'NONE' })
        vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'NONE' })
        vim.api.nvim_set_hl(0, 'MiniStatuslineFilename', { bg = 'NONE' })
        vim.api.nvim_set_hl(0, 'MiniStatuslineDevinfo', { bg = 'NONE' })
        vim.api.nvim_set_hl(0, 'MiniStatuslineInactive', { bg = 'NONE' })
      end
      transparent_statusline()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MatugenReloaded',
        callback = transparent_statusline,
      })
    end,
  },
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
      return vim.env.TERM_COLOR ~= 'dark'
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
