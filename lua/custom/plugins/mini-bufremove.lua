return {
  'echasnovski/mini.bufremove',
  version = false,
  config = function()
    vim.keymap.set('n', '<leader>o', function()
      local current = vim.api.nvim_get_current_buf()
      local buffers = vim.api.nvim_list_bufs()
      for _, buf in ipairs(buffers) do
        if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
          require('mini.bufremove').delete(buf, false)
        end
      end
    end, { desc = 'Close all other buffers' })
    require('mini.bufremove').setup {}
  end,
}
