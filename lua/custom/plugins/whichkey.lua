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
      { '<leader>d', group = 'Debug' },
      { '<leader>e', group = 'File Explorer' },
      { '<leader>f', group = 'Search' },
      { '<leader>l', group = 'Code Actions' },
      { '<leader>m', group = 'Testing' },
    }
    wk.setup {
      preset = 'modern',
      win = {
        height = { min = 10, max = 15 },
      },
      layout = {
        width = { min = 40, max = 40 },
        spacing = 6,
      },
    }
  end,
}
