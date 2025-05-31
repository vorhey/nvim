-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`

local general = vim.api.nvim_create_augroup('General', { clear = true })

vim.api.nvim_create_autocmd('Bufenter', {
  callback = function()
    vim.opt.formatoptions:remove { 'c', 'r', 'o' }
  end,
  group = general,
  desc = 'Disable new line comment',
})
vim.api.nvim_create_user_command('MasonInstallAll', function()
  require('lazy').load({ plugins = { 'mason-tool-installer.nvim' } })
  vim.cmd('MasonToolsInstall')
end, {
  desc = 'Install all Mason tools from ensure_installed list'
})
