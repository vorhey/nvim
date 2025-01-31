return {
  'echasnovski/mini.statusline',
  version = false,
  config = function()
    local utils = require 'utils'

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
          if vim.bo[buf].modified then
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
          local search = MiniStatusline.section_searchcount { trunc_width = 75 }
          local filename = MiniStatusline.section_filename { trunc_width = 120 }
          local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
          local diff = MiniStatusline.section_diff { trunc_width = 75 }
          local lsp = MiniStatusline.section_lsp { trunc_width = 75 }

          -- Custom spacing info section
          local spacing_info = ''
          if not MiniStatusline.is_truncated(120) then
            local et = vim.bo.expandtab
            local width = et and vim.bo.shiftwidth or vim.bo.tabstop
            spacing_info = (et and 'SP:' or 'TAB:') .. width
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

          local supermaven = utils.is_supermaven_enabled() and '' or ''
          local autoformat_indicator = is_autoformat_enabled() and '󰊄' or '󰉥'

          return MiniStatusline.combine_groups {
            { hl = 'MiniStatuslineDevinfo', strings = { '', filename } },
            '%<',
            '%=',
            { hl = 'ErrorMsg', strings = { macro_indicator } }, -- Add macro recording indicator
            { hl = 'WarningMsg', strings = { unsaved_indicator } },
            { hl = 'Added', strings = { supermaven } },
            { hl = 'MiniStatuslineFileinfo', strings = { autoformat_indicator, lsp, '', diff, fileinfo, '󱁐', spacing_info, diagnostics } },
            { hl = mode_hl, strings = { search } },
          }
        end,
      },
    }
  end,
}
