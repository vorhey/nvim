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
        DapBreakpoint = { fg = '#f79292' },
        DapBreakpointGreen = { fg = '#82ffac' },
        DapBreakpointYellow = { fg = '#ffd700' },
        DapBreakpointRejected = { fg = '#ff9ea8' },
        DapLogPoint = { fg = '#82ffac' },
        DapStopped = { fg = '#82ffac', bg = '#214283' },
        -- Diagnostics
        DiagnosticVirtualTextError = { fg = '#ff9ea8' },
        DiagnosticUnnecessary = { fg = '#696969' },
        DiagnosticSignHint = { fg = '#c6c6c6' },
        -- Telescope
        TelescopeNormal = { bg = 'NONE' },
        TelescopeBorder = { bg = 'NONE', fg = '#c6c6c6' },
        TelescopePromptNormal = { bg = 'NONE' },
        TelescopePromptBorder = { bg = 'NONE', fg = '#c6c6c6' },
        TelescopePromptTitle = { bg = 'NONE', fg = '#c6c6c6' },
        TelescopePreviewNormal = { bg = 'NONE' },
        TelescopePreviewBorder = { bg = 'NONE', fg = '#c6c6c6' },
        TelescopePreviewTitle = { bg = 'NONE', fg = '#c6c6c6' },
        TelescopeResultsNormal = { bg = 'NONE' },
        TelescopeResultsBorder = { bg = 'NONE', fg = '#c6c6c6' },
        TelescopeResultsTitle = { bg = 'NONE', fg = '#c6c6c6' },
        TelescopePromptCounter = { bg = 'NONE', fg = '#c6c6c6' },
        -- Mode and UI
        ModeMsg = { bg = 'NONE', fg = '#c6c6c6' },
        DapUIPlayPauseNC = { bg = 'NONE' },
        DapUIRestartNC = { bg = 'NONE' },
        DapUIUnavailableNC = { bg = 'NONE', fg = '#c6c6c6' },
        WinBar = { bg = 'NONE' },
        WinBarNC = { bg = 'NONE' },
        DapUIStopNC = { bg = 'NONE' },
        DapUIStepOverNC = { bg = 'NONE' },
        DapUIStepIntoNC = { bg = 'NONE' },
        DapUIStepBackNC = { bg = 'NONE' },
        DapUIStepOutNC = { bg = 'NONE' },
        -- Syntax
        ['@boolean'] = { fg = '#E29ECA', italic = false },
        ['@tag.attribute'] = { fg = '#d7c6f7' },
        ['@lsp.type.class.dart'] = { fg = '#e29eca', bold = true },
        ['@lsp.mod.constructor.dart'] = { fg = '#c6c6c6' },
      },
    }
    vim.cmd.colorscheme 'oldworld'
  end,
}
