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

    vim.keymap.set('i', '<C-s>', function()
      snippets.expand { match = false }
    end, { desc = 'snippets: pick and expand' })

    vim.keymap.set('i', '<Tab>', function()
      local session = snippets.get_session()
      if session then
        snippets.session.jump 'next'
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, false, true), 'n', false)
      end
    end, { desc = 'snippets: jump next tabstop' })

    vim.keymap.set('i', '<S-Tab>', function()
      local session = snippets.get_session()
      if session then
        snippets.session.jump 'prev'
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<S-Tab>', true, false, true), 'n', false)
      end
    end, { desc = 'snippets: jump prev tabstop' })
  end,
}
