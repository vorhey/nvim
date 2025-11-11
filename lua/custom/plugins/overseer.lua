return {
  'stevearc/overseer.nvim',
  config = function()
    local overseer = require 'overseer'
    overseer.setup {
      separator = '',
      task_list = {
        bindings = {
          ['<C-c>'] = 'Close',
          ['<C-j>'] = false,
          ['<C-k>'] = false,
          ['<C-l>'] = false,
          ['<C-h>'] = false,
        },
      },
    }
    vim.keymap.set('n', '<leader>rr', function()
      overseer.run_template()
    end, { desc = 'Overseer: Run task' })
    vim.keymap.set('n', '<leader>rt', function()
      overseer.toggle()
    end, { desc = 'Overseer: Toggle task list' })
  end,
}
