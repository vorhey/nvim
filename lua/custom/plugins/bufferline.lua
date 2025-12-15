return {
  'akinsho/bufferline.nvim',
  enabled = vim.g.neovide == true,
  version = '*',
  config = function()
    require('bufferline').setup {}
    if vim.g.neovide then
      for i = 1, 9 do
        vim.keymap.set({ 'n', 't' }, '<A-' .. i .. '>', function()
          vim.cmd('BufferLineGoToBuffer ' .. i)
        end, { desc = 'Go to buffer ' .. i })
        vim.keymap.set({ 'n', 't' }, '<A-S-' .. i .. '>', function()
          vim.cmd('BufferLineCloseBufferAt ' .. i)
        end, { desc = 'Close buffer ' .. i })
      end
      -- Move buffer left/right
      vim.keymap.set('n', '<A-Left>', '<Cmd>BufferLineMovePrev<CR>', { desc = 'Move buffer left' })
      vim.keymap.set('n', '<A-Right>', '<Cmd>BufferLineMoveNext<CR>', { desc = 'Move buffer right' })
    end
  end,
}
