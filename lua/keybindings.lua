-- Basic operations
vim.keymap.set('n', '<leader>Q', ':qa!<CR>', { desc = 'exit all' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'exit' })

if not vim.g.is_wsl then
  vim.keymap.set({ 'n', 'v' }, '<C-c>', '"+y', { silent = true, desc = 'copy to system clipboard' })
end

vim.keymap.set('i', '<C-r>"', '<C-r><C-p>"', { desc = 'paste default register with indent' })

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
-- vim.keymap.set('n', 'j', 'jzz')
-- vim.keymap.set('n', 'k', 'kzz')
-- vim.keymap.set('n', '#', '#zz')
-- vim.keymap.set('n', '*', '*zz')
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')
vim.keymap.set('n', '<C-o>', '<C-o>zz')
vim.keymap.set('n', '<C-i>', '<C-i>zz')
vim.keymap.set('i', '<M-;>', function()
  local line = vim.api.nvim_get_current_line()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-o>A' .. (line:match ';%s*$' and '' or ';') .. '<CR>', true, false, true), 'n', false)
end, { desc = 'append semicolon and new line' })

-- File tagging system (harpoon-like)
_G.tagged_files = { nil, nil, nil, nil }

local function tag_file(slot)
  local current_file = vim.fn.expand '%:p'
  if current_file == '' then
    vim.notify('No file to tag', vim.log.levels.WARN)
    return
  end
  _G.tagged_files[slot] = current_file
  vim.notify('Tagged ' .. vim.fn.expand '%:t' .. ' to slot ' .. slot, vim.log.levels.INFO)
end

local function goto_file(slot)
  local file = _G.tagged_files[slot]
  if not file then
    vim.notify('No file tagged in slot ' .. slot, vim.log.levels.WARN)
    return
  end
  if vim.fn.filereadable(file) == 0 then
    vim.notify('File no longer exists: ' .. file, vim.log.levels.ERROR)
    _G.tagged_files[slot] = nil
    return
  end
  vim.cmd('edit ' .. vim.fn.fnameescape(file))
end

-- Tag files (leader + number)
vim.keymap.set('n', '<leader>1', function()
  tag_file(1)
end)
vim.keymap.set('n', '<leader>2', function()
  tag_file(2)
end)
vim.keymap.set('n', '<leader>3', function()
  tag_file(3)
end)
vim.keymap.set('n', '<leader>4', function()
  tag_file(4)
end)

-- Navigate to tagged files (Alt + q/w/e/r)
vim.keymap.set({ 'n', 'i' }, '<M-q>', function()
  goto_file(1)
end, { desc = 'go to tagged file 1' })
vim.keymap.set({ 'n', 'i' }, '<M-w>', function()
  goto_file(2)
end, { desc = 'go to tagged file 2' })
vim.keymap.set({ 'n', 'i' }, '<M-e>', function()
  goto_file(3)
end, { desc = 'go to tagged file 3' })
vim.keymap.set({ 'n', 'i' }, '<M-r>', function()
  goto_file(4)
end, { desc = 'go to tagged file 4' })

vim.keymap.set('n', '[p', function()
  vim.cmd 'put!'
end, { desc = 'Put line above' })

-- Put a line **below** the current one and auto‑indent it
vim.keymap.set('n', ']p', function()
  vim.cmd 'put'
end, { desc = 'Put line below' })

if vim.g.neovide then
  -- vim.keymap.set({ 'n', 'v' }, '<C-S-v>', '"+p', { desc = 'Paste from system clipboard' })
  -- vim.keymap.set('i', '<C-S-v>', '<C-r>+', { desc = 'Paste from system clipboard' })
  vim.keymap.set({ 'n' }, '<leader>T', function()
    local name = vim.fn.input 'Terminal name: '
    vim.cmd 'terminal'
    if name ~= '' then
      vim.api.nvim_buf_set_name(0, 'term://' .. name)
    end
    vim.cmd 'startinsert'
  end)
  local function save()
    vim.cmd.write()
  end
  local function copy()
    vim.api.nvim_cmd({ cmd = 'yank', reg = '+' }, {})
  end
  local function paste()
    vim.api.nvim_paste(vim.fn.getreg '+', true, -1)
  end

  vim.keymap.set({ 'n', 'i', 'v' }, '<D-s>', save, { desc = 'Save' })
  vim.keymap.set('v', '<C-S-c>', copy, { silent = true, desc = 'Copy' })
  vim.keymap.set({ 'n', 'i', 'v', 'c', 't' }, '<C-S-v>', paste, { silent = true, desc = 'Paste' })
end
