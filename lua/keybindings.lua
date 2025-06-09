-- Basic operations
vim.keymap.set('n', '<leader>Q', ':qa!<CR>', { desc = 'exit (all)' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'exit' })

if not vim.g.is_wsl then
  vim.keymap.set({ 'n', 'v' }, '<C-c>', '"+y', { silent = true, desc = 'Copy to system clipboard' })
end

vim.keymap.set('i', '<C-r>"', '<C-r><C-p>"', { desc = 'Paste default register with indent' })

vim.keymap.set('n', '<C-m>', 'f{a<cr><esc>O', { desc = 'grow braces' })
