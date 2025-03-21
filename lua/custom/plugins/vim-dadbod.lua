return {
  'kristijanhusak/vim-dadbod-completion',
  dependencies = {
    {
      'tpope/vim-dadbod',
      cmd = 'DB',
    },
    'kristijanhusak/vim-dadbod-ui',
  },
  init = function()
    local data_path = vim.fn.stdpath 'data'
    vim.g.db_ui_auto_execute_table_helpers = 1
    vim.g.db_ui_save_location = data_path .. '/dadbod_ui'
    vim.g.db_ui_show_database_icon = true
    vim.g.db_ui_tmp_query_location = data_path .. '/dadbod_ui/tmp'
    vim.g.db_ui_use_nerd_fonts = true
    vim.g.db_ui_use_nvim_notify = true
    vim.g.db_ui_use_nerd_fonts = 1

    -- Configure blink.cmp for SQL files
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'sql',
      callback = function()
        vim.keymap.set('i', '<CR>', '<CR>', { buffer = true })
      end,
    })
    -- Helper function to close scratch buffer if exists
    local close_scratch_buffer = function()
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[bufnr].buftype == 'nofile' then
          vim.api.nvim_buf_delete(bufnr, { force = true })
        end
      end
    end

    local toggle_db_ui = function()
      close_scratch_buffer()
      vim.cmd 'DBUIToggle'
    end
    vim.keymap.set('n', '<leader>td', toggle_db_ui, { desc = 'toggle db ui' })
  end,
}
