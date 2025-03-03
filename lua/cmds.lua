vim.api.nvim_create_user_command('UnescapeJSON', [[%!sed 's/\\r\\n/\n/g; s/\\"/"/g; s/\\\//\//g']], {})
vim.api.nvim_create_user_command('TrimWhitespace', [[%s/\s\+$//e]], {})
vim.api.nvim_create_user_command('SnakeToCamel', [[%s/_\(\l\)/\u\1/g]], {})
vim.api.nvim_create_user_command('FormatJSON', [[%!jq .]], {})
