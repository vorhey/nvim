local general = vim.api.nvim_create_augroup('General', { clear = true })

vim.api.nvim_create_autocmd('Bufenter', {
  callback = function()
    vim.opt.formatoptions:remove { 'c', 'r', 'o' }
  end,
  group = general,
  desc = 'Disable new line comment',
})
vim.api.nvim_create_user_command('MasonInstallAll', function()
  require('lazy').load { plugins = { 'mason-tool-installer.nvim' } }
  vim.cmd 'MasonToolsInstall'
end, {
  desc = 'Install all Mason tools from ensure_installed list',
})

local resize = vim.api.nvim_create_augroup('ResizeSplits', { clear = true })

vim.api.nvim_create_autocmd('VimResized', {
  group = resize,
  desc = 'Keep splits at half-width after window resize',
  callback = function()
    if #vim.api.nvim_tabpage_list_wins(0) > 1 then
      vim.cmd 'wincmd ='
    end
  end,
})

vim.api.nvim_create_autocmd({ 'TermOpen', 'BufEnter' }, {
  pattern = { '*' },
  callback = function()
    if vim.opt.buftype:get() == 'terminal' then
      vim.cmd 'startinsert'
    end
  end,
})
