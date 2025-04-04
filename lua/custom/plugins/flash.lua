return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts = {},
  specs = {
    {
      'folke/snacks.nvim',
      opts = {
        picker = {
          win = {
            input = {
              keys = {
                ['<a-s>'] = { 'flash', mode = { 'n', 'i' } },
                ['s'] = { 'flash' },
              },
            },
          },
          actions = {
            flash = function(picker)
              require('flash').jump {
                pattern = '^',
                label = { after = { 0, 0 } },
                search = {
                  mode = 'search',
                  exclude = {
                    function(win)
                      return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'snacks_picker_list'
                    end,
                  },
                },
                action = function(match)
                  local idx = picker.list:row2idx(match.pos[1])
                  picker.list:_move(idx, true, true)
                end,
              }
            end,
          },
        },
      },
    },
  },
  keys = {
    {
      's',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump()
      end,
      desc = 'flash',
    },
  },
}
