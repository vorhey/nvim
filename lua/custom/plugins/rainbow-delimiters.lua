return {
  'hiphish/rainbow-delimiters.nvim',
  config = function()
    vim.g.rainbow_delimiters = {
      strategy = {
        [''] = 'rainbow-delimiters.strategy.global',
        vim = 'rainbow-delimiters.strategy.local',
      },
      query = { [''] = 'rainbow-delimiters' },
      priority = { [''] = 110 },
      highlight = {
        'RainbowDelimiterYellow',
        'RainbowDelimiterViolet',
      },
    }
  end,
}
