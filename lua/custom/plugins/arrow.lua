return {
  'otavioschwanck/arrow.nvim',
  dependencies = {
    { 'echasnovski/mini.icons' },
  },
  config = function()
    require('arrow').setup {
      show_icons = true,
      leader_key = '\\',
    }
  end,
}
