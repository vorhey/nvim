-- Leader key configuration
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- Display and UI settings
vim.opt.number = true -- Enable line numbers
vim.opt.relativenumber = true -- Enable relative line numbers
vim.opt.showmode = false -- Don't show mode in command line
vim.opt.termguicolors = true -- Enable terminal GUI colors
vim.opt.cursorline = true -- Highlight current line
vim.opt.signcolumn = 'yes' -- Always show sign column
vim.opt.showcmd = false -- Don't show command in status line
vim.opt.ruler = false -- Disable ruler
vim.opt.cmdheight = 1 -- Command line height
vim.opt.scrolloff = 999

-- Window and split behavior
vim.opt.splitright = true -- Open new splits to the right
vim.opt.splitbelow = true -- Open new splits below
vim.opt.pumheight = 12 -- Maximum number of popup menu items

-- Search settings
vim.opt.hlsearch = true -- Highlight search results
vim.opt.incsearch = true -- Jump to the first match
vim.opt.ignorecase = true -- Case-insensitive searching
vim.opt.smartcase = true -- Case-sensitive if search has capitals
vim.opt.inccommand = 'split' -- Preview substitutions
vim.o.wildignorecase = true -- Ignore case in file/command completion

-- Indentation and whitespace
vim.opt.shiftwidth = 2 -- Size of indent
vim.opt.tabstop = 2 -- Size of tab
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.autoindent = true -- Copy indent from current line
vim.opt.smartindent = true -- Smart autoindenting
vim.opt.breakindent = true -- Maintain indent when wrapping
vim.opt.list = true -- Show whitespace characters
vim.opt.listchars = {
  tab = '  ',
  trail = '·',
  nbsp = '␣',
}

-- Folding configuration
vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldtext = ''
vim.opt.foldcolumn = 'auto:1'

-- Performance and technical settings
vim.opt.updatetime = 250 -- Faster completion
vim.opt.timeoutlen = 300 -- Time to wait for mapped sequence
vim.opt.undofile = true -- Save undo history
vim.opt.backupcopy = 'yes' -- Backup file copying method
vim.opt.mouse = 'a' -- Enable mouse support

-- Status line and window bar
vim.opt.shortmess:append { W = true, I = true, c = true, C = true }

-- Terminal specific settings
vim.cmd [[let &t_Cs = "\e[4:3m"]] -- Enable undercurl
vim.cmd [[let &t_Ce = "\e[4:0m"]]

vim.opt.winbar = "%=%{%v:lua.get_file_icon()%}%{%v:lua.require('utils').get_relative_filename()%}%="
