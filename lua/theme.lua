return {
  enabled = true,
  'dgox16/oldworld.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('oldworld').setup {
      integrations = {
        neo_tree = true,
        telescope = true,
      },
      styles = {
        booleans = { italic = false },
        comments = { italic = false },
        keywords = { italic = false },
        functions = { italic = false },
        strings = { italic = false },
        variables = { italic = false },
        types = { italic = false },
      },
      highlight_overrides = {
        Normal = { bg = 'NONE' },
        NormalFloat = { bg = 'NONE' },
        NormalNC = { bg = 'NONE' },
        TabLineFill = { bg = 'NONE' },
        FoldColumn = { bg = 'NONE' },
        Pmenu = { bg = 'NONE' },
        StatusLine = { bg = 'NONE', fg = '#c6c6c6' },
        StatusLineNC = { bg = 'NONE' },
        SignColumn = { bg = 'NONE' },
        FloatBorder = { bg = 'NONE' },
        FloatTitle = { bg = 'NONE' },
        LineNr = { fg = '#c6c6c6' },
        CursorLine = { bg = 'NONE' },
        Visual = { bg = '#214283' },
        PmenuSel = { bg = '#82ffac', fg = '#000000' },
        CmpBorder = { fg = '#c6c6c6' },
        Comment = { fg = '#989898', italic = false },
        Type = { fg = '#c6c6c6', italic = false },
        Folded = { fg = '#c6c6c6' },

        -- DAP
        DapBreakpoint = { fg = '#f79292' }, -- Default red breakpoint
        DapBreakpointGreen = { fg = '#82ffac' }, -- Green breakpoint
        DapBreakpointYellow = { fg = '#ffd700' }, -- Yellow breakpoint
        DapBreakpointRejected = { fg = '#ff9ea8' }, -- Rejected breakpoint
        DapLogPoint = { fg = '#82ffac' }, -- Log point
        DapStopped = { fg = '#82ffac', bg = '#214283' }, -- Stopped line

        -- Virtual text colors (shown inline)
        DiagnosticVirtualTextError = { fg = '#ff9ea8' },
        DiagnosticUnnecessary = { fg = '#696969' },
        DiagnosticSignHint = { fg = '#c6c6c6' },

        ['@boolean'] = { fg = '#E29ECA', italic = false },
        ['@tag.attribute'] = { fg = '#d7c6f7' },

        ['@lsp.type.class.dart'] = { fg = '#e29eca', bold = true }, -- or your preferred style
        ['@lsp.mod.constructor.dart'] = { fg = '#c6c6c6' },
      },
    }
    vim.cmd.colorscheme 'oldworld'
    vim.cmd [[
      hi ModeMsg guibg=NONE ctermbg=NONE guifg=#c6c6c6
    ]]
    vim.defer_fn(function()
      vim.cmd [[
        hi DapUIPlayPauseNC guibg=NONE
        hi DapUIRestartNC guibg=NONE
        hi DapUIUnavailableNC guibg=NONE guifg=#c6c6c6
        hi WinBar guibg=NONE
        hi WinBarNC guibg=NONE
        hi DapUIStopNC guibg=NONE
        hi DapUIStepOverNC guibg=NONE
        hi DapUIStepIntoNC guibg=NONE
        hi DapUIStepBackNC guibg=NONE
        hi DapUIStepOutNC guibg=NONE
      ]]
    end, 1000)
  end,
}
