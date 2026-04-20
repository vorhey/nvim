return {
  'nvim-mini/mini.snippets',
  version = false,
  event = 'InsertEnter',
  config = function()
    local snippets = require 'mini.snippets'
    snippets.setup {
      snippets = {
        snippets.gen_loader.from_lang(),
      },
    }
    vim.keymap.set('i', '<M-s>', function()
      snippets.expand { match = false }
    end, { desc = 'snippets: pick and expand' })
  end,
}
