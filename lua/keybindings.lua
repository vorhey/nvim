local utils = require 'utils'
-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous Diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next Diagnostic message' })
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- save file
vim.keymap.set('n', '<C-s>', ':w!<CR>', { desc = 'Save file', silent = true })
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>l', { desc = 'Save file', silent = true })

-- nvimtree
vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'explorer' })

-- center screen
vim.keymap.set('n', '<c-d>', utils.lazy '<c-d>zz', { desc = 'Scroll down half screen' })

-- expand line
vim.keymap.set('n', '<C-m>', utils.expand_line, { desc = 'Expand' })

-- insert semicolon at the end of the line
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
-- resize
vim.keymap.set('n', '<C-Right>', ':vertical resize +5<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-Left>', ':vertical resize -5<CR>', { noremap = true, silent = true })

-- toggle autoformatting
vim.keymap.set('n', '<leader>ta', utils.toggle_autoformat, { desc = 'toggle autoformat', noremap = true, silent = true })

-- remap visual block mode
-- vim.keymap.set('n', '<A-v>', '<C-v>')
vim.keymap.set('n', '<A-v>', function()
  vim.api.nvim_put({ vim.g.last_system_clip }, '', false, true)
end)

-- line pseudo-text objects (https://gist.github.com/romainl/c0a8b57a36aec71a986f1120e1931f20#file-pseudo-text-objects-vim-L13)
vim.keymap.set('x', 'il', 'g_o^', { desc = 'inner line text object' })
vim.keymap.set('o', 'il', ':<C-u>normal vil<CR>', { desc = 'inner line text object' })
vim.keymap.set('x', 'al', '$o0', { desc = 'around line text object' })
vim.keymap.set('o', 'al', ':<C-u>normal val<CR>', { desc = 'around line text object' })

-- toggle supermaven
vim.keymap.set('n', '<leader>tm', utils.toggle_supermaven, { desc = 'toggle supermaven' })

-- copy previous line till the end of line
vim.keymap.set('i', '<c-y>', utils.copy_line_above, { noremap = true, silent = true })

-- exit
vim.keymap.set('n', '<leader>Q', ':qa!<CR>', { desc = 'exit (all)' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'exit' })

-- Copy/paste with system clipboard
vim.keymap.set({ 'n', 'x' }, 'gy', '"+y', { desc = 'Copy to system clipboard' })
vim.keymap.set('n', 'gp', '"+p', { desc = 'Paste from system clipboard' })
-- - Paste in Visual with `P` to not copy selected text (`:h v_P`)
vim.keymap.set('x', 'gp', '"+P', { desc = 'Paste from system clipboard' })

vim.keymap.set('n', 'j', 'gj', { noremap = true })
vim.keymap.set('n', 'k', 'gk', { noremap = true })
vim.keymap.set('n', 'j', "v:count ? 'j' : 'gj'", { noremap = true, expr = true })
vim.keymap.set('n', 'k', "v:count ? 'k' : 'gk'", { noremap = true, expr = true })

vim.keymap.set('n', 'j', "v:count == 0 ? 'gjzz' : 'jzz'", { expr = true, noremap = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gkzz' : 'kzz'", { expr = true, noremap = true })
