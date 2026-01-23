return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  opts = {},
  keys = {
    { '<leader>ss', function()
      vim.cmd('bufdo bwipeout')
      require('persistence').select()
    end, desc = 'Select session' },
    { '<leader>sw', function() require('persistence').save() end, desc = 'Write session' },
    { '<leader>sd', function() require('persistence').stop() end, desc = 'Stop session tracking' },
    { '<leader>sc', function()
      vim.cmd('bufdo bwipeout')
      require('persistence').load { last = true }
    end, desc = 'Load last session' },
  },
}
