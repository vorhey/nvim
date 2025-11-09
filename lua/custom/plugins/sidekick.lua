return {
  'folke/sidekick.nvim',
  -- Plugin options
  opts = {
    nes = { enabled = true },
    cli = {
      mux = {
        backend = 'tmux',
        enabled = false,
      },
      tools = {},
    },
  },
  -- Keybindings for Sidekick features
  keys = {
    {
      '<leader>aa', -- Toggle Sidekick CLI (normal mode)
      function()
        local ok, cli = pcall(require, 'sidekick.cli')
        if ok and cli then
          cli.toggle()
        else
          vim.notify('Sidekick CLI not available', vim.log.levels.WARN)
        end
      end,
      mode = { 'n' },
      desc = 'Sidekick: Toggle CLI',
    },
    {
      '<leader>af', -- Send current file to Sidekick CLI (normal mode)
      function()
        local ok, cli = pcall(require, 'sidekick.cli')
        if ok and cli then
          cli.send { msg = '{file}' }
        else
          vim.notify('Sidekick CLI not available', vim.log.levels.WARN)
        end
      end,
      mode = { 'n' },
      desc = 'Sidekick: Send File',
    },
    {
      '<leader>av', -- Send visual selection to Sidekick CLI (visual mode)
      function()
        require('sidekick.cli').send { msg = '{selection}' }
      end,
      mode = { 'x' },
      desc = 'Sidekick: Send Visual Selection',
    },
    {
      '<tab>', -- Jump/apply next edit suggestion or fallback to Tab (normal & insert mode)
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not pcall(require, 'sidekick') then
          return '<Tab>' -- fallback if plugin not loaded
        end
        if not require('sidekick').nes_jump_or_apply() then
          return '<Tab>' -- fallback to normal tab
        end
      end,
      mode = { 'n', 'i' },
      expr = true,
      desc = 'Sidekick: Goto/Apply Next Edit Suggestion',
    },
  },
}
