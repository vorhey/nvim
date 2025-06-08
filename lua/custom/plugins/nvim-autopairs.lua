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
    npairs.clear_rules()
    -- Add only the double quote rule with flyout behavior
    npairs.add_rule(Rule('"', '"'):with_move(function(opts)
      return opts.char == '"'
    end))
    npairs.add_rule(Rule('(', ')', 'lua'))
    npairs.add_rule(Rule('[', ']', 'lua'))
    npairs.add_rule(Rule('{', '}', 'lua'))
  end,
}
