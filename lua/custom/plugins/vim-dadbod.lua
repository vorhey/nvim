return {
  'kristijanhusak/vim-dadbod-completion',
  dependencies = { { 'tpope/vim-dadbod', cmd = 'DB' }, 'kristijanhusak/vim-dadbod-ui', 'hrsh7th/nvim-cmp' },
  keys = {
    {
      '<leader>td',
      function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == 'nofile' then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end
        vim.cmd 'DBUIToggle'
      end,
      desc = 'Toggle DB UI',
    },
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
  end,
  config = function()
    local data_path = vim.fn.stdpath 'data'
    vim.g.db_ui_auto_execute_table_helpers = 1
    vim.g.db_ui_save_location = data_path .. '/dadbod_ui'
    vim.g.db_ui_show_database_icon = true
    vim.g.db_ui_tmp_query_location = data_path .. '/dadbod_ui/tmp'
    vim.g.db_ui_use_nvim_notify = true
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'dbui',
      callback = function()
        local cmp = require 'cmp'
        local config = cmp.get_config()
        table.insert(config.sources, 1, { name = 'vim-dadbod-completion' })
        cmp.setup.buffer(config)
      end,
    })
  end,
}
