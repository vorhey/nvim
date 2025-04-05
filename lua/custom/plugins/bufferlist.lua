return {
  'EL-MASTOR/bufferlist.nvim',
  lazy = true,
  keys = { { '<leader><leader>', ':BufferList<CR>', desc = 'Open bufferlist' } },
  cmd = 'BufferList',
  opts = {
    win_keymaps = {
      {
        '<C-x>', -- Ctrl+x to close buffer under cursor
        function(opts)
          local curpos = vim.fn.line '.'
          local buf_id = opts.buffers[curpos]
          vim.cmd('bwipeout | silent! bdelete ' .. buf_id)
          -- Reopen bufferlist to refresh
          opts.open_bufferlist()
        end,
        { desc = 'BufferList: close buffer under cursor' },
      },
      {
        '<cr>', -- Enter key to open buffer under cursor
        function(opts)
          local curpos = vim.fn.line '.'
          vim.cmd('bwipeout | buffer ' .. opts.buffers[curpos])
        end,
        { desc = 'BufferList: open buffer under cursor' },
      },
    },
  },
}
