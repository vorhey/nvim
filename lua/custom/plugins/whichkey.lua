-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VimEnter'
--
-- which loads which-key before all the UI elements are loaded. Events can be
-- normal autocommands events (`:help autocmd-events`).
--
-- Then, because we use the `config` key, the configuration only runs
-- after the plugin has been loaded:
--  config = function() ... end

return {
  -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  config = function() -- This is the function that runs, AFTER loading
    local wk = require 'which-key'
    wk.add {
      mode = { 'n' },
      {
        { '<leader>y', icon = { icon = '', color = 'orange' } },
        { '<leader>p', icon = { icon = '', color = 'orange' } },
        { '<leader>o', icon = { icon = '󰅙', color = 'orange' }, desc = 'close all other buffers' },
        { '<leader>O', icon = { icon = '󰅙', color = 'orange' }, desc = 'close current buffer' },
        { '<leader>q', icon = { icon = '󰈆', color = 'orange' }, desc = 'quit' },
        { '<leader>Q', icon = { icon = '󰈆', color = 'orange' }, desc = 'quit all force' },
        { '<leader>e', icon = { icon = '󱏒', color = 'orange' }, desc = 'explorer' },
        { '<leader><leader>', icon = { icon = '', color = 'orange' } },
        { '<leader>a', group = 'avante', icon = { icon = '󰁤', color = 'grey' } },
        { '<leader>d', group = 'debug', icon = { icon = '', color = 'grey' } },
        { '<leader>t', group = 'features', icon = { icon = '', color = 'grey' } },
        { '<leader>f', group = 'find', icon = { icon = '', color = 'grey' } },
        { '<leader>h', group = 'git', icon = { icon = '󰊢', color = 'grey' } },
        { '<leader>l', group = 'lsp', icon = { icon = '', color = 'grey' } },
        { '<leader>m', group = 'testing', icon = { icon = '', color = 'grey' } },
      },
    }
    wk.setup {
      preset = 'helix',
      sort = { 'manual' },
    }
  end,
}
