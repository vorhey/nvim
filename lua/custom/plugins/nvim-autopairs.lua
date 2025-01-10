return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    local npairs = require 'nvim-autopairs'
    npairs.setup {
      ignored_next_char = string.gsub([[ [%w%.%(%{%[%$'"`%s] ]], '%s+', ''),
    }
  end,
}
