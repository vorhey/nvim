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
    vim.keymap.set('n', '<leader>rl', function()
      overseer.load_template()
    end, { desc = 'Overseer: Load template' })
    vim.keymap.set('n', '<leader>rq', function()
      overseer.quick_action()
    end, { desc = 'Overseer: Quick action' })
    vim.keymap.set('n', '<leader>rs', function()
      overseer.run_action 'restart'
    end, { desc = 'Overseer: Restart last task' })
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'OverseerList', 'OverseerOutput' },
      callback = function()
        vim.opt_local.statusline = ' '
      end,
    })
  end,
}
