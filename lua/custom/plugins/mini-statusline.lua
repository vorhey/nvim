return {
  'nvim-mini/mini.statusline',
  event = 'VeryLazy',
  version = false,
  config = function()
    local function is_autoformat_enabled()
      return vim.g.disable_autoformat ~= true
    end

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'alpha', 'Scratch' },
      callback = function()
        vim.b.ministatusline_disable = true
      end,
    })

    local function count_unsaved_buffers()
      local unsaved_count = 0
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
          local filetype = vim.bo[buf].filetype
          if vim.bo[buf].modified and filetype ~= 'dap-repl' then
            unsaved_count = unsaved_count + 1
          end
        end
      end
      return unsaved_count
    end

    -- Rainbow buffer dots section
    local function section_buffers(args)
      if MiniStatusline.is_truncated(args.trunc_width) then
        return ''
      end

      local rainbow_colors = {
        'DiagnosticError', -- Red
        'DiagnosticWarn', -- Yellow/Orange
        'DiagnosticInfo', -- Blue
        'DiagnosticHint', -- Cyan/Light blue
        'String', -- Green
        'Function', -- Purple/Magenta
      }

      local buffers = {}
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
          local buftype = vim.bo[buf].buftype
          local buflisted = vim.bo[buf].buflisted
          local name = vim.api.nvim_buf_get_name(buf)

          -- Use the recommended approach: check buflisted and buftype
          -- buflisted controls if buffer appears in buffer list (:ls)
          -- buftype == '' means normal file buffer (not terminal, quickfix, etc.)
          if buflisted and buftype == '' and name ~= '' then
            table.insert(buffers, buf)
          end
        end
      end

      if #buffers == 0 then
        return ''
      end

      local current_buf = vim.api.nvim_get_current_buf()
      local dots = {}
      for i, buf in ipairs(buffers) do
        local color_index = ((i - 1) % #rainbow_colors) + 1
        local hl_group = rainbow_colors[color_index]
        local buf_name = vim.api.nvim_buf_get_name(buf)

        -- Check if this buffer is tagged (access global tagged_files)
        local tag_letter = nil
        local jump_letters = { 'q', 'w', 'e', 'r' }
        if _G.tagged_files then
          for slot = 1, 4 do
            if _G.tagged_files[slot] == buf_name then
              tag_letter = '[' .. jump_letters[slot] .. ']'
              break
            end
          end
        end

        -- Highlight current buffer with different symbol and color
        if buf == current_buf then
          local symbol = tag_letter and ('●' .. tag_letter .. '°') or '●°'
          table.insert(dots, { hl = 'Title', strings = { symbol } })
        else
          local symbol = tag_letter and ('●' .. tag_letter) or '●'
          table.insert(dots, { hl = hl_group, strings = { symbol } })
        end
      end

      return dots
    end

    -- Simple visual selection section following mini.statusline patterns
    local function section_selection(args)
      if MiniStatusline.is_truncated(args.trunc_width) then
        return ''
      end
      local mode = vim.fn.mode()
      if not mode:match '[vV]' then
        return ''
      end
      local lines = math.abs(vim.fn.line '.' - vim.fn.line 'v') + 1
      return string.format('(%dL)', lines)
    end

    require('mini.statusline').setup {
      content = {
        active = function()
          local mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
          local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
          local has_diagnostics = diagnostics == '' and '' or ''
          local search = MiniStatusline.section_searchcount { trunc_width = 75 }
          local selection = section_selection { trunc_width = 75 }
          local buffer_indicator = section_buffers { trunc_width = 120 }
          local lsp_clients = vim.lsp.get_clients { bufnr = 0 }
          local lsp = ''
          local names = {}
          for _, client in ipairs(lsp_clients) do
            if client.name ~= 'copilot' then
              table.insert(names, client.name)
            end
          end
          if #names > 0 then
            lsp = '󰬓 ' .. table.concat(names, ', ')
          end
          local git_status = vim.b.minidiff_summary_string or vim.b.gitsigns_status
          local has_diff = git_status == '' and '' or ''

          -- Custom spacing info section
          local spacing_info = ''
          if not MiniStatusline.is_truncated(120) then
            local et = vim.bo.expandtab
            local width = et and vim.bo.shiftwidth or vim.bo.tabstop
            spacing_info = (et and '󱁐 :' or '󰌒 :') .. width
          end

          -- Count unsaved buffers
          local unsaved_count = count_unsaved_buffers()
          local unsaved_indicator = ''
          if unsaved_count > 0 then
            unsaved_indicator = string.format(' [%d unsaved]', unsaved_count)
          end

          -- Macro recording indicator
          local macro_indicator = ''
          local recording_register = vim.fn.reg_recording()
          if recording_register ~= '' then
            macro_indicator = ' REC @' .. recording_register
          end

          local autoformat_indicator = is_autoformat_enabled() and '󰗴' or '󰉥'

          local is_copilot_enabled = function()
            return vim.g.copilot_enabled == true
          end

          local copilot = is_copilot_enabled() and '  ' or '  '

          local groups = {}

          -- Add buffer dots
          if type(buffer_indicator) == 'table' then
            for _, dot in ipairs(buffer_indicator) do
              table.insert(groups, dot)
            end
          end

          -- Add spacer and right-aligned content
          table.insert(groups, '%=')
          table.insert(groups, { hl = 'ErrorMsg', strings = { macro_indicator } })
          table.insert(groups, { hl = 'WarningMsg', strings = { unsaved_indicator } })
          table.insert(groups, {
            hl = 'MiniStatuslineFileinfo',
            strings = { autoformat_indicator, lsp, spacing_info, has_diff, has_diagnostics, copilot },
          })
          table.insert(groups, { hl = mode_hl, strings = { search, selection } })

          return MiniStatusline.combine_groups(groups)
        end,
      },
    }
  end,
}
