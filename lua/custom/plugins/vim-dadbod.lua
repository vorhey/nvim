return {
  'kristijanhusak/vim-dadbod-completion',
  ft = { 'sql' },
  dependencies = {
    'tpope/vim-dadbod',
    cmd = 'DB',
  },
  cmd = {
    'DB',
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
  end,
}
