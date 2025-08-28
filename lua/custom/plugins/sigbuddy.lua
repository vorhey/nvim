return {
  'vorhey/sigbuddy.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('sigbuddy').setup {
      provider = 'gemini',
      providers = {
        gemini = {
          api_key = os.getenv 'GEMINI_API_KEY',
          model = 'gemini-1.5-flash',
        },
      },
    }
  end,
}
