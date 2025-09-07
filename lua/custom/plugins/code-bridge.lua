return {
  'vorhey/code-bridge.nvim',
  config = function()
    require('code-bridge').setup {
      provider = 'codex', -- 'claude' | 'codex' | 'gemini' (default 'claude')
      interactive = { use_telescope = true },
    }
  end,
}
