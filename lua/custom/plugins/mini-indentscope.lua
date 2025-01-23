return {
  'echasnovski/mini.indentscope',
  opts = {
    symbol = '│',
    options = { try_as_border = true },
  },
  init = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = {
        'alpha',
        'dashboard',
        'fzf',
        'help',
        'lazy',
        'mason',
        'neo-tree',
        'notify',
        'snacks_dashboard',
        'snacks_notif',
        'snacks_terminal',
        'snacks_win',
        'toggleterm',
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
}
