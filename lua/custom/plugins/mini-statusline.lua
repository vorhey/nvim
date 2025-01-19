return {
  'echasnovski/mini.statusline',
  enabled = false,
  version = false,
  config = function()
    require('mini.statusline').setup {
      content = {
        active = function()
          local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
          local git = MiniStatusline.section_git { trunc_width = 40 }
          local diff = MiniStatusline.section_diff { trunc_width = 75 }
          local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
          local search = MiniStatusline.section_searchcount { trunc_width = 75 }

          -- Custom spacing info section
          local spacing_info = ''
          if not MiniStatusline.is_truncated(120) then
            local et = vim.bo.expandtab
            local width = et and vim.bo.shiftwidth or vim.bo.tabstop
            spacing_info = (et and 'SP:' or 'TAB:') .. width
          end

          return MiniStatusline.combine_groups {
            { hl = mode_hl, strings = { mode } },
            { hl = 'MiniStatuslineDevinfo', strings = { git, diff } },
            '%<',
            '%=',
            { hl = 'MiniStatuslineFileinfo', strings = { spacing_info, diagnostics } },
            { hl = mode_hl, strings = { search } },
          }
        end,
      },
    }
  end,
}
