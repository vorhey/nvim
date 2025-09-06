return {
  'vorhey/code-bridge.nvim',
  config = function()
    require('code-bridge').setup {
      -- Active provider selection
      provider = 'codex', -- 'claude' | 'codex' | 'gemini' (default 'claude')
      -- Provider definitions (override CLI/flags as needed for your system)
      providers = {
        claude = { cli = 'claude', tmux = { window_name = 'claude', process_name = 'claude' }, chat_flags = { new = { '-p' }, cont = { '-c', '-p' } } },
        codex = { cli = 'codex', tmux = { window_name = 'codex', process_name = 'codex' }, chat_flags = { new = { '-p' }, cont = { '-c', '-p' } } },
        gemini = { cli = 'gemini', tmux = { window_name = 'gemini', process_name = 'gemini' }, chat_flags = { new = { '-p' }, cont = { '-c', '-p' } } },
      },
      -- Note: Adjust the CLI names and chat_flags above if your provider CLI
      -- expects different arguments for new/continued chats.
      tmux = {
        target_mode = 'window_name', -- 'window_name', 'current_window', 'find_process'
        -- window_name/process_name fall back if provider.tmux not set
        window_name = 'claude',
        process_name = 'claude',
        switch_to_target = true,
        find_node_process = true,
      },
      interactive = { use_telescope = true },
    }
  end,
}
