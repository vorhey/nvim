return {
  'vorhey/code-bridge.nvim',
  config = function()
    require('code-bridge').setup {
      provider = 'codex', -- 'claude' | 'codex' | 'gemini' (default 'claude')
    }
    vim.keymap.set('n', '<leader><leader>', ':CodeBridgeAddContext<CR>', { desc = 'add file' })
    vim.keymap.set('v', '<leader><leader>', ':CodeBridgeAddContext<CR>', { desc = 'add selection' })
    vim.keymap.set('n', '<leader>cc', ':CodeBridgeUse<CR>', { desc = 'switch provider' })
    vim.keymap.set('n', '<leader>cx', ':CodeBridgeCursorDiagnostic<CR>', { desc = 'add diagnostic' })
    vim.keymap.set('n', '<leader>cd', ':CodeBridgeDiff<CR>', { desc = 'add diff' })
  end,
}
