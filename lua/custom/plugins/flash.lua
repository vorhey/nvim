return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  -- stylua: ignore
  keys = {
    { "<CR>", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
  },
  config = function()
    require('flash').setup {
      highlight = {
        backdrop = true,
        matches = false,
      },
      action = function(match, state)
        vim.api.nvim_win_set_cursor(match.win, match.pos)
        vim.cmd 'normal! zz'
      end,
    }
  end,
}
