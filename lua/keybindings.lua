local utils = require 'utils'

-- Basic operations
vim.keymap.set('n', '<leader>Q', ':qa!<CR>', { desc = 'exit (all)' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'exit' })
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Text manipulation
vim.keymap.set('n', '<C-m>', utils.expand_line, { desc = 'Expand' })
vim.keymap.set('i', '<M-;>', function()
  local line = vim.api.nvim_get_current_line()
  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  local next_paren = line:find(')', col + 1)
  if next_paren then
    local new_line = line:sub(1, next_paren) .. ';' .. line:sub(next_paren + 1)
    vim.api.nvim_set_current_line(new_line)
  end
end, { desc = 'Add semicolon after expression' })
vim.keymap.set('i', '<M-:>', function()
  local line = vim.api.nvim_get_current_line()
  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  local next_paren = line:find(')', col + 1)
  if next_paren then
    local new_line = line:sub(1, next_paren) .. ',' .. line:sub(next_paren + 1)
    vim.api.nvim_set_current_line(new_line)
  end
end)

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
end, { silent = true, noremap = true, desc = 'Scroll left horizontally' })

vim.keymap.set('n', 'zL', '<Plug>(ScrollRightCenter)', { silent = true, desc = 'Scroll right' })
vim.keymap.set('n', 'zH', '<Plug>(ScrollLeftCenter)', { silent = true, desc = 'Scroll right' })

if not utils.is_wsl() then
  vim.keymap.set({ 'n', 'v' }, '<C-c>', '"+y', { silent = true, desc = 'Copy to system clipboard' })
end

vim.keymap.set('i', '<C-r>"', '<C-r><C-p>"', { desc = 'Paste default register with indent' })
