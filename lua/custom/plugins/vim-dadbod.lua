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

    -- Default DBUI key mappings
    vim.g.db_ui_winwidth = 40

    -- Define default mappings
    vim.g.db_ui_default_mappings = 1

    -- Add explicit default mappings for clarity
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'dbui',
      callback = function()
        -- Connection/Database/Table management
        vim.keymap.set('n', '<CR>', '<Plug>(DBUI_SelectLine)', { buffer = true, silent = true, desc = 'select line or expand/collapse' })
        vim.keymap.set('n', 'o', '<Plug>(DBUI_SelectLine)', { buffer = true, silent = true, desc = 'select line or expand/collapse' })
        vim.keymap.set('n', 'S', '<Plug>(DBUI_SelectLineVsplit)', { buffer = true, silent = true, desc = 'open in vertical split' })
        vim.keymap.set('n', 's', '<Plug>(DBUI_SelectLineSplit)', { buffer = true, silent = true, desc = 'open in horizontal split' })
        vim.keymap.set('n', 'd', '<Plug>(DBUI_DeleteLine)', { buffer = true, silent = true, desc = 'delete item under cursor' })
        vim.keymap.set('n', 'R', '<Plug>(DBUI_Redraw)', { buffer = true, silent = true, desc = 'force redraw' })
        vim.keymap.set('n', 'A', '<Plug>(DBUI_AddConnection)', { buffer = true, silent = true, desc = 'add new connection' })
        vim.keymap.set('n', 'H', '<Plug>(DBUI_ToggleDetails)', { buffer = true, silent = true, desc = 'toggle details' })

        -- Navigation
        vim.keymap.set('n', 'r', '<Plug>(DBUI_RefreshPage)', { buffer = true, silent = true, desc = 'refresh page' })
        vim.keymap.set('n', 'K', '<Plug>(DBUI_GotoPrevSibling)', { buffer = true, silent = true, desc = 'go to previous sibling' })
        vim.keymap.set('n', 'J', '<Plug>(DBUI_GotoNextSibling)', { buffer = true, silent = true, desc = 'go to next sibling' })

        -- Save, edit, execute queries
        vim.keymap.set('n', 'q', '<Plug>(DBUI_Quit)', { buffer = true, silent = true, desc = 'close dbui' })
        vim.keymap.set('n', 'e', '<Plug>(DBUI_ExecQuery)', { buffer = true, silent = true, desc = 'execute query' })
        vim.keymap.set('n', 'E', '<Plug>(DBUI_ExecQueryAtCursor)', { buffer = true, silent = true, desc = 'execute query at cursor' })
        vim.keymap.set('n', 'y', '<Plug>(DBUI_YankQuery)', { buffer = true, silent = true, desc = 'yank query' })
        vim.keymap.set('n', 'u', '<Plug>(DBUI_UpdateQuery)', { buffer = true, silent = true, desc = 'update query' })
      end,
    })

    -- SQL buffer mappings
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'sql',
      callback = function()
        vim.keymap.set('n', '<leader>W', '<Plug>(DBUI_SaveQuery)', { buffer = true, silent = true, desc = 'save query' })
        vim.keymap.set('n', '<leader>E', '<Plug>(DBUI_ExecuteQuery)', { buffer = true, silent = true, desc = 'execute query' })
        vim.keymap.set('n', '<leader>S', '<Plug>(DBUI_ExecuteQuery)', { buffer = true, silent = true, desc = 'execute query' })
        vim.keymap.set('v', '<leader>E', '<Plug>(DBUI_ExecuteQueryVisual)', { buffer = true, silent = true, desc = 'execute visual selection' })
        vim.keymap.set('v', '<leader>S', '<Plug>(DBUI_ExecuteQueryVisual)', { buffer = true, silent = true, desc = 'execute visual selection' })
        vim.keymap.set('i', '<CR>', '<CR>', { buffer = true })
      end,
    })
  end,
}
