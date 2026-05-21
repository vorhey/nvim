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
      win = { layout = 'float' },
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
      '<m-.>',
      function()
        require('sidekick.cli').toggle()
      end,
      desc = 'Sidekick Toggle',
      mode = { 'n', 't', 'i', 'x' },
    },
    {
      '<leader>as',
      function()
        require('sidekick.cli').select()
      end,
      desc = 'sidekick: select CLI tool',
    },
  },
}
