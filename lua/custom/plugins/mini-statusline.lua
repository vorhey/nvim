return {
  'echasnovski/mini.statusline',
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

    require('mini.statusline').setup {
      content = {
        active = function()
          local mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
          local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
          local has_diagnostics = diagnostics == '' and '' or ''
          local search = MiniStatusline.section_searchcount { trunc_width = 75 }
          local lsp = #vim.lsp.get_clients { bufnr = 0 } > 0 and '󰬓' or ''
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

          return MiniStatusline.combine_groups {
            '%=',
            { hl = 'ErrorMsg', strings = { macro_indicator } },
            { hl = 'WarningMsg', strings = { unsaved_indicator } },
            {
              hl = 'MiniStatuslineFileinfo',
              strings = { autoformat_indicator, lsp, spacing_info, has_diff, has_diagnostics, copilot },
            },
            { hl = mode_hl, strings = { search } },
          }
        end,
      },
    }
  end,
}
