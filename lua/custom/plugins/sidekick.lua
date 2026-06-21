return {
  'folke/sidekick.nvim',
  -- Plugin options
  opts = {
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
      '<leader><leader>',
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
      '<leader><leader>',
      function()
        require('sidekick.cli').send { msg = '{selection}' }
      end,
      mode = { 'x' },
      desc = 'sidekick: send selection',
    },
    {
      '<M-.>',
      function()
        require('sidekick.cli').toggle()
      end,
      desc = 'Sidekick Toggle',
      mode = { 'n', 't', 'i', 'x' },
    },
    {
      '<leader>ss',
      function()
        require('sidekick.cli').select()
      end,
      desc = 'sidekick: select',
      mode = { 'n' },
    },
    {
      '<leader>sd',
      function()
        require('sidekick.cli').send { prompt = 'diagnostics' }
      end,
      desc = 'sidekick: send buffer diagnostics',
      mode = { 'n' },
    },
    {
      '<leader>sD',
      function()
        require('sidekick.cli').send { prompt = 'diagnostics_all' }
      end,
      desc = 'sidekick: send all diagnostics',
      mode = { 'n' },
    },
  },
}
