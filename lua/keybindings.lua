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

vim.keymap.set('n', '<Plug>(ScrollRightCenter)', function()
  -- First scroll right
  vim.cmd 'silent! normal! zL'

  -- Get dimensions, view and position
  local win_width = vim.api.nvim_win_get_width(0)
  local left_col = vim.fn.winsaveview().leftcol
  local cursor_row = vim.api.nvim_win_get_cursor(0)[1]
  local new_col = left_col + math.floor(win_width / 2)

  -- Set cursor to new position
  vim.api.nvim_win_set_cursor(0, { cursor_row, new_col })

  -- Make dot-repeatable with repeat.vim
  vim.cmd 'silent! call repeat#set("\\<Plug>(ScrollRightCenter)", v:count)'
end, { silent = true, noremap = true, desc = 'Scroll right horizontally' })

vim.keymap.set('n', 'z.', '<Plug>(ScrollRightCenter)', { silent = true, desc = 'Scroll right' })
vim.keymap.set('n', 'zH', '<Cmd>normal! zH<CR><Cmd>silent! call repeat#set("zH", v:count)<CR>', { silent = true, desc = 'Scroll left horizontally' })
