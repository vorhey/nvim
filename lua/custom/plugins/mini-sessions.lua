return {
  'nvim-mini/mini.sessions',
  version = false,
  config = function()
    require('mini.sessions').setup {}
    vim.keymap.set('n', '<leader>ss', function()
      MiniSessions.select 'read'
    end, { desc = 'Select session' })
    vim.keymap.set('n', '<leader>sw', function()
      vim.ui.input({ prompt = 'Session name: ' }, function(name)
        if name and name ~= '' then
          MiniSessions.write(name)
        end
      end)
    end, { desc = 'Write session' })
    vim.keymap.set('n', '<leader>sd', function()
      MiniSessions.select 'delete'
    end, { desc = 'Delete session' })
    vim.keymap.set('n', '<leader>sc', function()
      MiniSessions.write(nil, { force = true })
    end, { desc = 'Update current session' })
  end,
}
