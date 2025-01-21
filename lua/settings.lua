-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
-- vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true

vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true

vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true

vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true

vim.opt.shiftwidth = 2

vim.opt.tabstop = 2

vim.opt.expandtab = true

vim.opt.autoindent = true

vim.opt.smartindent = true

vim.opt.showcmd = false

-- remove ~ from empty lines
vim.opt.fillchars = {
  foldopen = '',
  foldclose = '',
  fold = ' ',
  foldsep = ' ',
  diff = '╱',
  eob = ' ',
}

-- ignore casing
vim.o.wildignorecase = true

-- relative line numbers
vim.wo.relativenumber = true

-- folding settings
-- Set folding method to 'expr' for expression-based folds
vim.o.foldmethod = 'expr'

-- Use Tree-sitter as the folding mechanism
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'

-- Start with all folds open
vim.o.foldlevelstart = 99

-- Enable folding
vim.o.foldenable = true

-- Show the fold column; '0' means it's not displayed
vim.o.foldcolumn = '0'

-- Keep folds open unless they are deep
vim.o.foldlevel = 99

-- Set noruler
vim.o.ruler = false

-- Terminal gui colors
vim.opt.termguicolors = true

-- Wrap lines
vim.opt.wrap = false
vim.opt.linebreak = false

-- Matching brackets
vim.opt.showmatch = true

-- Popup
vim.opt.pumheight = 12 -- Maximum number of entries in a popup

-- Shortmess
vim.opt.shortmess:append { W = true, I = true, c = true, C = true }

-- Cmdheight
vim.o.cmdheight = 1

vim.opt.lazyredraw = true

vim.opt.ttyfast = true

-- Undercurl
vim.cmd [[let &t_Cs = "\e[4:3m"]]
vim.cmd [[let &t_Ce = "\e[4:0m"]]

-- Theme
vim.cmd [[
  highlight Normal guibg=NONE
  highlight NormalFloat guibg=NONE
  highlight NormalNC guibg=NONE
  highlight TabLineFill guibg=NONE
  highlight FoldColumn guibg=NONE
  highlight Pmenu guibg=NONE
  highlight StatusLine guibg=NONE guifg=#c6c6c6
  highlight StatusLineNC guibg=NONE guifg=#989898
  highlight SignColumn guibg=NONE
  highlight FloatBorder guibg=NONE
  highlight FloatTitle guibg=NONE
  highlight LineNr guifg=#c6c6c6
  highlight CursorLine guibg=NONE
  highlight Visual guibg=#214283
  highlight PmenuSel guibg=#82ffac guifg=#000000
  highlight CmpBorder guifg=#c6c6c6
  highlight Comment guifg=#989898 gui=NONE
  highlight Type guifg=#c6c6c6 gui=NONE
  highlight Folded guifg=#c6c6c6
  highlight DapBreakpoint guifg=#f79292
  highlight DapBreakpointGreen guifg=#82ffac
  highlight DapBreakpointYellow guifg=#ffd700
  highlight DapBreakpointRejected guifg=#ff9ea8
  highlight DapLogPoint guifg=#82ffac
  highlight DapStopped guifg=#82ffac guibg=#214283
  highlight DiagnosticVirtualTextError guifg=#ff9ea8
  highlight DiagnosticUnnecessary gui=undercurl
  highlight DiagnosticSignHint guifg=#c6c6c6
  highlight ModeMsg guibg=NONE guifg=#c6c6c6
  highlight DapUIPlayPauseNC guibg=NONE
  highlight DapUIRestartNC guibg=NONE
  highlight DapUIUnavailableNC guibg=NONE guifg=#c6c6c6
  highlight WinBar guibg=NONE
  highlight WinBarNC guibg=NONE
  highlight DapUIStopNC guibg=NONE
  highlight DapUIStepOverNC guibg=NONE
  highlight DapUIStepIntoNC guibg=NONE
  highlight DapUIStepBackNC guibg=NONE
  highlight DapUIStepOutNC guibg=NONE
]]
