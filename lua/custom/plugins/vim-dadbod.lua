return {
  'kristijanhusak/vim-dadbod-completion',
  dependencies = {
    { 'tpope/vim-dadbod', cmd = 'DB' },
    'kristijanhusak/vim-dadbod-ui',
    'saghen/blink.cmp',
    {
      'davesavic/dadbod-ui-yank',
      config = function()
        require('dadbod-ui-yank').setup()
      end,
    },
  },
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
    {
      '<leader>zs',
      function()
        local ts = vim.treesitter
        local cursor = vim.api.nvim_win_get_cursor(0)
        local row, _ = cursor[1] - 1, cursor[2] -- Convert to 0-based

        -- Get the treesitter parser
        local parser = ts.get_parser(0, 'sql')
        if not parser then
          vim.notify('SQL parser not available', vim.log.levels.ERROR)
          return
        end

        local tree = parser:parse()[1]
        local root = tree:root()

        -- Find the statement that contains the cursor position
        local function find_statement_containing_cursor(node)
          if node:type():match 'statement' then
            local start_row, _, end_row, _ = node:range()
            if start_row <= row and row <= end_row then
              return node
            end
          end

          for child in node:iter_children() do
            local result = find_statement_containing_cursor(child)
            if result then
              return result
            end
          end

          return nil
        end

        local node = find_statement_containing_cursor(root)

        if not node or node:type() == 'source_file' then
          vim.notify('No SQL statement found at cursor', vim.log.levels.WARN)
          return
        end

        -- Get the range of the statement
        local start_row, _, end_row, _ = node:range()

        -- Execute the statement range
        vim.cmd((start_row + 1) .. ',' .. (end_row + 1) .. 'DB')
      end,
      desc = 'Execute current SQL statement',
      ft = { 'sql', 'mysql', 'plsql' },
    },
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.vim_dadbod_completion_lowercase_keywords = 1
  end,
  config = function()
    local data_path = vim.fn.stdpath 'data'
    vim.g.db_ui_auto_execute_table_helpers = 1
    vim.g.db_ui_save_location = data_path .. '/dadbod_ui'
    vim.g.db_ui_show_database_icon = true
    vim.g.db_ui_tmp_query_location = data_path .. '/dadbod_ui/tmp'
    vim.g.db_ui_use_nvim_notify = true
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'sql', 'mysql', 'plsql', 'dbui' },
      callback = function()
        -- Configure vim-dadbod-completion for blink.cmp via compat layer
        require('blink.cmp').setup {
          sources = {
            default = { 'dadbod' },
            providers = {
              dadbod = {
                name = 'Dadbod',
                module = 'blink.compat.source',
                opts = {
                  name = 'vim-dadbod-completion',
                },
              },
            },
          },
          completion = {
            keyword_length = 1,
            list = {
              max_items = 25,
            },
          },
        }
        local wk = require 'which-key'
        wk.add {
          buffer = vim.api.nvim_get_current_buf(),
          { '<leader>zs', desc = 'Execute current SQL statement', icon = { icon = '󰜎', color = 'blue' }, mode = 'n' },
          { '<leader>S', desc = 'Execute SQL buffer', icon = { icon = '󰌵', color = 'blue' }, mode = 'n' },
          { '<leader>W', desc = 'Save SQL buffer', icon = { icon = '󰈙', color = 'blue' }, mode = 'n' },
          { '<leader>R', desc = 'Toggle result layout', icon = { icon = '󰒲', color = 'blue' }, mode = 'n' },
          { '<leader>E', desc = 'Edit bind parameters', icon = { icon = '󰅛', color = 'blue' }, mode = 'n' },
          { '<leader>S', desc = 'Execute selected SQL', mode = 'v' },
        }
      end,
    })
  end,
}
