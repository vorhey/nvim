return {
  -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  config = function() -- This is the function that runs, AFTER loading
    local wk = require 'which-key'
    wk.add {
      mode = { 'n' },
      {
        { '<leader>o', icon = { icon = '󰅙', color = 'azure' } },
        { '<leader>O', icon = { icon = '󰅙', color = 'azure' } },
        { '<leader>Q', icon = { icon = '󰈆', color = 'azure' } },
        { '<leader>e', icon = { icon = '󱏒', color = 'azure' } },
        { '<leader>u', desc = 'undo', icon = { icon = '', color = 'red' } },
        { '<leader><leader>', desc = 'add file', icon = { icon = '', color = 'red' } },
        { '<leader>a', group = 'sidekick', icon = { icon = '', color = 'grey' } },
        { '<leader>d', group = 'debug', icon = { icon = '', color = 'grey' } },
        { '<leader>t', group = 'toggle', icon = { icon = '', color = 'grey' } },
        { '<leader>f', group = 'find', icon = { icon = '', color = 'grey' } },
        { '<leader>g', group = 'git', icon = { icon = '󰊢', color = 'grey' } },
        { '<leader>h', group = 'harvgate', icon = { icon = '󰁤', color = 'grey' } },
        { '<leader>l', group = 'lsp', icon = { icon = '', color = 'grey' } },
        { '<leader>n', group = 'neotest', icon = { icon = '', color = 'grey' } },
        { '<leader>m', group = 'multicursor/mermaid', icon = { icon = '󰇀', color = 'grey' } },
        { '<leader>r', group = 'overseer', icon = { icon = '', color = 'grey' } },
        { '<leader>x', group = 'trouble', icon = { icon = '󰗶', color = 'grey' } },
        { '<leader>s', group = 'dadbod', icon = { icon = '󰆼', color = 'grey' } },
      },
    }
    wk.setup {
      preset = 'helix',
      delay = 0,
      filter = function(mapping)
        return mapping.desc and mapping.desc ~= ''
      end,
    }
  end,
}
