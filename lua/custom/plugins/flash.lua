return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  ---@type Flash.Config
  opts = {
    action = function(match, _)
      vim.api.nvim_win_set_cursor(match.win, match.pos)
      vim.cmd 'normal! zz'
    end,
  },
  keys = {
    {
      '<CR>',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump()
      end,
      desc = 'Flash',
    },
  },
}
