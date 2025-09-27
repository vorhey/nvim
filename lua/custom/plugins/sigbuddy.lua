return {
  'vorhey/sigbuddy.nvim',
  cmd = 'Sigbuddy',
  lazy = true,
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('sigbuddy').setup {
      provider = 'gemini',
      providers = {
        gemini = {
          api_key = os.getenv 'GEMINI_API_KEY',
          model = 'gemini-2.5-flash',
        },
      },
    }
  end,
}
