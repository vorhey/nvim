return {
  'echasnovski/mini.tabline',
  version = false,
  config = function()
    require('mini.tabline').setup {}
    local function get_nth_buffer(n)
      local buffers = vim.tbl_filter(function(buf)
        return vim.bo[buf].buflisted
      end, vim.api.nvim_list_bufs())
      return buffers[n]
    end

    vim.keymap.set('n', '<M-q>', function()
      local buf = get_nth_buffer(1)
      if buf then
        vim.api.nvim_set_current_buf(buf)
      end
    end, { silent = true })
    vim.keymap.set('n', '<M-w>', function()
      local buf = get_nth_buffer(2)
      if buf then
        vim.api.nvim_set_current_buf(buf)
      end
    end, { silent = true })
    vim.keymap.set('n', '<M-e>', function()
      local buf = get_nth_buffer(3)
      if buf then
        vim.api.nvim_set_current_buf(buf)
      end
    end, { silent = true })
    vim.keymap.set('n', '<M-r>', function()
      local buf = get_nth_buffer(4)
      if buf then
        vim.api.nvim_set_current_buf(buf)
      end
    end, { silent = true })
  end,
}
