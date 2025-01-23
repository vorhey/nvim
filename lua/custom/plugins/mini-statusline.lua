return {
  'echasnovski/mini.statusline',
  version = false,
  config = function()
    require('mini.statusline').setup {
      content = {
        active = function()
          local mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
          local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
          local search = MiniStatusline.section_searchcount { trunc_width = 75 }
          local filename = MiniStatusline.section_filename { trunc_width = 120 }
          local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
          local diff = MiniStatusline.section_diff { trunc_width = 75 }

          -- Custom spacing info section
          local spacing_info = ''
          if not MiniStatusline.is_truncated(120) then
            local et = vim.bo.expandtab
            local width = et and vim.bo.shiftwidth or vim.bo.tabstop
            spacing_info = (et and 'SP:' or 'TAB:') .. width
          end

          return MiniStatusline.combine_groups {
            { hl = 'MiniStatuslineDevinfo', strings = { '', filename } },
            '%<',
            '%=',
            { hl = 'MiniStatuslineFileinfo', strings = { '', diff, fileinfo, '󱁐', spacing_info, diagnostics } },
            { hl = mode_hl, strings = { search } },
          }
        end,
      },
    }
  end,
}
