return {
  -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  config = function() -- This is the function that runs, AFTER loading
    local wk = require 'which-key'
    wk.add {
      mode = { 'n' },
      {
        { '<leader>o', icon = { icon = '󰅙', color = 'green' } },
        { '<leader>O', icon = { icon = '󰅙', color = 'green' } },
        { '<leader>q', icon = { icon = '󰈆', color = 'green' } },
        { '<leader>Q', icon = { icon = '󰈆', color = 'green' } },
        { '<leader>e', icon = { icon = '󱏒', color = 'green' } },
        { '<leader>n', icon = { icon = '󰇀', color = 'green' } },
        { '<leader>N', icon = { icon = '󰆿', color = 'green' } },
        { '<leader>s', icon = { icon = '󰇀', color = 'green' } },
        { '<leader>S', icon = { icon = '󰆿', color = 'green' } },
        { '<leader><leader>', icon = { icon = '', color = 'green' } },
        { '<leader>d', group = 'debug', icon = { icon = '', color = 'grey' } },
        { '<leader>t', group = 'toggle', icon = { icon = '', color = 'grey' } },
        { '<leader>f', group = 'find', icon = { icon = '', color = 'grey' } },
        { '<leader>g', group = 'git', icon = { icon = '󰊢', color = 'grey' } },
        { '<leader>h', group = 'harvgate', icon = { icon = '󰁤', color = 'grey' } },
        { '<leader>l', group = 'lsp', icon = { icon = '', color = 'grey' } },
        { '<leader>m', group = 'testing', icon = { icon = '', color = 'grey' } },
      },
    }
    wk.setup {
      preset = 'helix',
      sort = { 'manual' },
      delay = 0,
    }
  end,
}
