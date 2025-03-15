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

-- Toggle features
vim.keymap.set('n', '<leader>ta', utils.toggle_autoformat, { desc = 'toggle autoformat', noremap = true, silent = true })
