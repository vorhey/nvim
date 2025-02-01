return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    local npairs = require 'nvim-autopairs'
    local Rule = require 'nvim-autopairs.rule'
    npairs.setup {}
    for _, i in ipairs(npairs.config.rules) do
      i.key_map = nil
    end
    npairs.add_rules {
      Rule('function%(.*%)%s*$', 'end', 'lua')
        :use_regex(true)
        :set_end_pair_length(3) -- end is 3 characters
        :replace_endpair(function()
          return '\n\t\nend' -- add newlines and tab
        end),
    }
  end,
}
