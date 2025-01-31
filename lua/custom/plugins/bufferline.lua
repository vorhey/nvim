return {
  'akinsho/bufferline.nvim',
  version = '*',
  config = function()
    local bufferline = require 'bufferline'
    bufferline.setup {
      options = {
        style_preset = bufferline.style_preset.no_italic,
      },
    }
    -- Bufferline switching keymaps
    vim.keymap.set('n', '<A-q>', '<cmd>BufferLineGoToBuffer 1<CR>', { desc = 'Switch to buffer 1', silent = true })
    vim.keymap.set('n', '<A-w>', '<cmd>BufferLineGoToBuffer 2<CR>', { desc = 'Switch to buffer 2', silent = true })
    vim.keymap.set('n', '<A-e>', '<cmd>BufferLineGoToBuffer 3<CR>', { desc = 'Switch to buffer 3', silent = true })
    vim.keymap.set('n', '<A-r>', '<cmd>BufferLineGoToBuffer 4<CR>', { desc = 'Switch to buffer 4', silent = true })
    vim.keymap.set('n', '<M-h>', '<cmd>BufferLineMovePrev<CR>', { desc = 'Move buffer left', silent = true })
    vim.keymap.set('n', '<M-l>', '<cmd>BufferLineMoveNext<CR>', { desc = 'Move buffer right', silent = true })
    vim.keymap.set('n', '[b', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Cycle to prev buffer', silent = true })
    vim.keymap.set('n', ']b', '<cmd>BufferLineCycleNext<CR>', { desc = 'Cycle to next buffer', silent = true })
  end,
}
