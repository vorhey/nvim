return {
  'vorhey/inline-code.nvim',
  cmd = 'InlineCode',
  keys = {
    { '<leader>aa', '<cmd>InlineCode analyze<cr>', desc = 'inline-code: analyze buffer' },
    { '<leader>ac', '<cmd>InlineCode clear<cr>', desc = 'inline-code: clear suggestions' },
    { '<leader>at', '<cmd>InlineCode toggle<cr>', desc = 'inline-code: toggle' },
    { '<leader>ar', '<cmd>InlineCode refresh<cr>', desc = 'inline-code: refresh render' },
  },
  config = function()
    require('inline-code').setup {
      provider = 'gemini',
      model = 'gemini-3.1-flash-lite',
      -- api_key read from $GEMINI_API_KEY (set in ~/.zshenv)
      max_lines = 2000,
      timeout = 60000,
      preset = 'modern',
      overflow = 'wrap',
      show_label = true,
      show_suggestion = true,
      disabled_ft = {},
    }
  end,
}
