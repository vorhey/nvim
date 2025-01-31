return {
  'echasnovski/mini.pairs',
  version = false,
  event = 'VeryLazy',
  opts = {
    skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
    skip_unbalanced = true,
    markdown = true,
  },
  config = function(_, opts)
    local pairs = require 'mini.pairs'
    pairs.setup(opts)
    local open = pairs.open
    ---@diagnostic disable-next-line: duplicate-set-field
    pairs.open = function(pair, neigh_pattern)
      local o, c = pair:sub(1, 1), pair:sub(2, 2)
      local line = vim.api.nvim_get_current_line()
      local cursor = vim.api.nvim_win_get_cursor(0)
      local next = line:sub(cursor[2] + 1, cursor[2] + 1)
      local before = line:sub(1, cursor[2])
      if opts.markdown and o == '`' and vim.bo.filetype == 'markdown' and before:match '^%s*``' then
        return '`\n```' .. vim.api.nvim_replace_termcodes('<up>', true, true, true)
      end
      if opts.skip_next and next ~= '' and next:match(opts.skip_next) then
        return o
      end
      if opts.skip_unbalanced and next == c and c ~= o then
        local _, count_open = line:gsub(vim.pesc(pair:sub(1, 1)), '')
        local _, count_close = line:gsub(vim.pesc(pair:sub(2, 2)), '')
        if count_close > count_open then
          return o
        end
      end
      return open(pair, neigh_pattern)
    end
  end,
}
