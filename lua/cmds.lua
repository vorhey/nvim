vim.api.nvim_create_user_command('UnescapeJSON', [[%!sed 's/\\r\\n/\n/g; s/\\"/"/g; s/\\\//\//g']], {})
vim.api.nvim_create_user_command('TrimWhitespace', [[%s/\s\+$//e]], {})
vim.api.nvim_create_user_command('SnakeToCamel', [[%s/_\(\l\)/\u\1/g]], {})
vim.api.nvim_create_user_command('FormatJSON', [[%!jq .]], {})
vim.api.nvim_create_user_command('CopyMessages', function()
  local messages = vim.api.nvim_cmd({ cmd = 'messages' }, { output = true })
  if messages == '' then
    vim.notify('No messages to copy.', vim.log.levels.INFO)
    return
  end

  if vim.fn.has 'clipboard' ~= 1 then
    vim.notify('Cannot copy messages: no clipboard provider available.', vim.log.levels.ERROR)
    return
  end

  local ok, result = pcall(vim.fn.setreg, '+', messages, 'v')
  if not ok or result ~= 0 then
    vim.notify('Failed to copy messages to clipboard: ' .. tostring(result), vim.log.levels.ERROR)
    return
  end

  vim.notify('Messages copied to clipboard.', vim.log.levels.INFO)
end, { desc = 'Copy message history to the system clipboard' })
