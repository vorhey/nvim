return {
  'echasnovski/mini.notify',
  version = false,
  config = function()
    local win_config = function()
      local has_statusline = vim.o.laststatus > 0
      local bottom_space = vim.o.cmdheight + (has_statusline and 1 or 0)
      return { anchor = 'SE', col = vim.o.columns, row = vim.o.lines - bottom_space, border = 'none' }
    end

    require('mini.notify').setup {
      content = {
        sort = function(notif_arr)
          table.sort(notif_arr, function(a, b)
            return a.ts_update > b.ts_update
          end)
          return { notif_arr[1] }
        end,
        format = function(notify)
          local icons = {
            ['ERROR'] = '  ',
            ['WARN'] = '  ',
            ['INFO'] = '  ',
            ['DEBUG'] = '  ',
            ['TRACE'] = '»  ',
          }
          local icon = icons[notify.level] or ''
          return icon .. notify.msg
        end,
      },
      window = {
        config = win_config,
        winblend = 0,
      },
    }

    vim.notify = require('mini.notify').make_notify()
    vim.keymap.set('n', '<leader>fn', function()
      require('mini.notify').show_history()
    end, { desc = 'show notification history' })
  end,
}
