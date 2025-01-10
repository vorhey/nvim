return {
  'echasnovski/mini.hipatterns',
  version = false,
  config = function()
    local hipatterns = require 'mini.hipatterns'
    hipatterns.setup {
      highlighters = {
        todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
        hex_color = hipatterns.gen_highlighter.hex_color(),
      },
    }
  end,
}
