return {
  'akinsho/bufferline.nvim',
  enabled = vim.g.neovide == true,
  version = '*',
  config = function()
    require('mini.icons').mock_nvim_web_devicons()
    require('bufferline').setup {
      options = {
        show_buffer_icons = true,
      },
    }
    if vim.g.neovide then
      for i = 1, 9 do
        vim.keymap.set({ 'n', 't' }, '<A-' .. i .. '>', function()
          vim.cmd('BufferLineGoToBuffer ' .. i)
        end, { desc = 'Go to buffer ' .. i })
        vim.keymap.set({ 'n', 't' }, '<A-S-' .. i .. '>', function()
          vim.cmd('BufferLineCloseBufferAt ' .. i)
        end, { desc = 'Close buffer ' .. i })
      end

      vim.keymap.set('n', '<A-Left>', '<Cmd>BufferLineMovePrev<CR>', { desc = 'Move buffer left' })
      vim.keymap.set('n', '<A-Right>', '<Cmd>BufferLineMoveNext<CR>', { desc = 'Move buffer right' })
      vim.keymap.set({ 'n', 't' }, '<M-[>', '<Cmd>tabprevious<CR>', { desc = 'Previous project tab' })
      vim.keymap.set({ 'n', 't' }, '<M-]>', '<Cmd>tabnext<CR>', { desc = 'Next project tab' })
      vim.keymap.set({ 'n', 't' }, '<M-x>', '<Cmd>tabclose<CR>', { desc = 'Close project tab' })
      vim.keymap.set({ 'n', 't' }, '<M-o>', '<Cmd>tabnew<CR>', { desc = 'New project tab' })
    end
  end,
}
