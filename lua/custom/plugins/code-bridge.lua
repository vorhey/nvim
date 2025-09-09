return {
  'vorhey/code-bridge.nvim',
  config = function()
    require('code-bridge').setup {
      provider = 'codex', -- 'claude' | 'codex' | 'gemini' (default 'claude')
    }
    vim.keymap.set('n', '<leader>cc', ':CodeBridgeAddContextAndSwitch<CR>', { desc = 'send file or selection' })
    vim.keymap.set('v', '<leader>cc', ':CodeBridgeAddContextAndSwitch<CR>', { desc = 'send selection' })
    vim.keymap.set('n', '<leader>cf', ':CodeBridgeAddContext<CR>', { desc = 'add file/selection (no switch)' })
    vim.keymap.set('v', '<leader>cf', ':CodeBridgeAddContext<CR>', { desc = 'add selection (no switch)' })
    vim.keymap.set('n', '<leader>cd', ':CodeBridgeDiff<CR>', { desc = 'send git diff' })
    vim.keymap.set('n', '<leader>cs', ':CodeBridgeDiffStaged<CR>', { desc = 'send staged diff' })
  end,
}
