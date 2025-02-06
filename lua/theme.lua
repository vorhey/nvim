return {
  enabled = true,
  'dgox16/oldworld.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('oldworld').setup {
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
        PmenuSel = { bg = '#383838', fg = '#c6c6c6' },
        CmpBorder = { fg = '#3d3d3d' },
        Comment = { fg = '#989898', italic = false },
        Type = { fg = '#c6c6c6', italic = false },
        Folded = { fg = '#c6c6c6' },
        -- DAP
        DapBreakpoint = { fg = '#f79292' },
        DapBreakpointGreen = { fg = '#82ffac' },
        DapBreakpointYellow = { fg = '#ffd700' },
        DapBreakpointRejected = { fg = '#ff9ea8' },
        DapLogPoint = { fg = '#82ffac' },
        DapStopped = { fg = '#82ffac', bg = '#214283' },
        -- Diagnostics
        DiagnosticVirtualTextError = { fg = '#ff9ea8' },
        DiagnosticUnnecessary = { undercurl = true },
        DiagnosticSignHint = { fg = '#c6c6c6' },
        -- Mode and UI
        ModeMsg = { bg = 'NONE', fg = '#c6c6c6' },
        DapUIPlayPauseNC = { bg = 'NONE' },
        DapUIRestartNC = { bg = 'NONE' },
        DapUIUnavailableNC = { bg = 'NONE', fg = '#c6c6c6' },
        WinBar = { bg = 'NONE', fg = '#c6c6c6' },
        WinBarNC = { bg = 'NONE' },
        DapUIStopNC = { bg = 'NONE' },
        DapUIStepOverNC = { bg = 'NONE' },
        DapUIStepIntoNC = { bg = 'NONE' },
        DapUIStepBackNC = { bg = 'NONE' },
        DapUIStepOutNC = { bg = 'NONE' },
        MiniStatusLineModeInsert = { bg = '#d7c6f7', fg = '#000000' },
        -- Syntax
        ['@boolean'] = { fg = '#E29ECA', italic = false },
        ['@tag.attribute'] = { fg = '#d7c6f7' },
        ['@lsp.type.class.dart'] = { fg = '#e29eca', bold = true },
        ['@lsp.mod.constructor.dart'] = { fg = '#c6c6c6' },
        -- Blink
        BlinkCmpMenu = { bg = 'NONE' },
        BlinkCmpDoc = { bg = 'NONE' },
        BlinkCmpDocBorder = { bg = 'NONE' },
        BlinkCmpMenuBorder = { bg = 'NONE' },
        BlinkCmpDocSeparator = { bg = 'NONE' },
        -- Snippet
        SnippetTabStop = { bg = 'NONE' },
        -- Winbar
      },
    }
    vim.cmd.colorscheme 'oldworld'
  end,
}
