return {
  'kristijanhusak/vim-dadbod-completion',
  ft = { 'sql' },
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
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'sql',
      callback = function()
        local cmp = require 'cmp'
        local sources = vim.tbl_map(function(source)
          return { name = source.name }
        end, cmp.get_config().sources)
        table.insert(sources, { name = 'vim-dadbod-completion' })
        cmp.setup.buffer { sources = sources }
        vim.keymap.set('i', '<CR>', '<CR>', { buffer = true })
      end,
    })
  end,
}
