return {
  'vorhey/code-bridge.nvim',
  config = function()
    require('code-bridge').setup {
      provider = 'codex', -- 'claude' | 'codex' | 'gemini' (default 'claude')
    }
    vim.keymap.set('n', '<leader>cc', ':CodeBridgeAddContextAndSwitch<CR>', { desc = 'Send file or selection' })
    vim.keymap.set('v', '<leader>cc', ':CodeBridgeAddContextAndSwitch<CR>', { desc = 'Send selection' })
    vim.keymap.set('n', '<leader>cf', ':CodeBridgeAddContext<CR>', { desc = 'Add file/selection (no switch)' })
    vim.keymap.set('v', '<leader>cf', ':CodeBridgeAddContext<CR>', { desc = 'Add selection (no switch)' })
    vim.keymap.set('n', '<leader>cd', ':CodeBridgeDiff<CR>', { desc = 'Send git diff' })
    vim.keymap.set('n', '<leader>cs', ':CodeBridgeDiffStaged<CR>', { desc = 'Send staged diff' })
  end,
}
