-- Basic operations
vim.keymap.set('n', '<leader>Q', ':qa!<CR>', { desc = 'exit (all)' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'exit' })

if not vim.g.is_wsl then
  vim.keymap.set({ 'n', 'v' }, '<C-c>', '"+y', { silent = true, desc = 'copy to system clipboard' })
end

vim.keymap.set('i', '<C-r>"', '<C-r><C-p>"', { desc = 'paste default register with indent' })

vim.keymap.set('n', '<C-m>', '0f{a<cr><esc>O', { desc = 'grow braces' })

local center_cursor = function()
  -- Get dimensions, view and position
  local win_width = vim.api.nvim_win_get_width(0)
  local left_col = vim.fn.winsaveview().leftcol
  local cursor_row = vim.api.nvim_win_get_cursor(0)[1]
  local new_col = left_col + math.floor(win_width / 2)

  -- Set cursor to new position
  vim.api.nvim_win_set_cursor(0, { cursor_row, new_col })
end

vim.keymap.set('n', '<Plug>(ScrollRightCenter)', function()
  -- First scroll right
  vim.cmd 'silent! normal! zL'
  center_cursor()
  -- Make dot-repeatable with repeat.vim
  vim.cmd 'silent! call repeat#set("\\<Plug>(ScrollRightCenter)", v:count)'
end, { silent = true, noremap = true, desc = 'Scroll right horizontally' })

vim.keymap.set('n', '<Plug>(ScrollLeftCenter)', function()
  -- First scroll left
  vim.cmd 'silent! normal! zH'
  center_cursor()
  -- Make dot-repeatable with repeat.vim
  vim.cmd 'silent! call repeat#set("\\<Plug>(ScrollLeftCenter)", v:count)'
end, { silent = true, noremap = true, desc = 'scroll left horizontally' })

vim.keymap.set('n', 'zL', '<Plug>(ScrollRightCenter)', { silent = true, desc = 'Scroll right' })
vim.keymap.set('n', 'zH', '<Plug>(ScrollLeftCenter)', { silent = true, desc = 'Scroll right' })

vim.keymap.set('n', '<C-U>', '11kzz')
vim.keymap.set('n', '<C-D>', '11jzz')
vim.keymap.set('n', 'j', 'jzz')
vim.keymap.set('n', 'k', 'kzz')
vim.keymap.set('n', '#', '#zz')
vim.keymap.set('n', '*', '*zz')
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')
vim.keymap.set('n', '<C-o>', '<C-o>zz')
vim.keymap.set('n', '<C-i>', '<C-i>zz')
vim.keymap.set('i', '<M-;>', function()
  local line = vim.api.nvim_get_current_line()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-o>A' .. (line:match ';%s*$' and '' or ';') .. '<CR>', true, false, true), 'n', false)
end, { desc = 'append semicolon and new line' })
