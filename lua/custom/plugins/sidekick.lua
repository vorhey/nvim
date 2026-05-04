local function send_sidekick_context(msg, fallback)
  local ok, cli = pcall(require, 'sidekick.cli')
  if not ok or not cli then
    vim.notify('Sidekick CLI not available', vim.log.levels.WARN)
    return
  end

  local sent, err = pcall(cli.send, { msg = msg })
  if sent then
    return
  end

  local rendered = cli.render { msg = msg }
  if not rendered or rendered == '' then
    vim.notify(('Sidekick send failed: %s'):format(err), vim.log.levels.WARN)
    return
  end

  vim.fn.setreg('+', rendered)
  vim.notify(('Sidekick send failed; %s'):format(fallback), vim.log.levels.WARN)
end

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
      win = { layout = 'float' },
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
      '<leader><leader>',
      function()
        send_sidekick_context('{file}', 'copied file context to clipboard')
      end,
      mode = { 'n' },
      desc = 'Sidekick: Send File Context',
    },
    {
      '<leader><leader>',
      function()
        send_sidekick_context('{selection}', 'copied selection context to clipboard')
      end,
      mode = { 'x' },
      desc = 'Sidekick: Send Selection Context',
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
    {
      '<leader>as',
      function()
        require('sidekick.cli').select()
      end,
      desc = 'Select CLI Tool',
    },
  },
}
