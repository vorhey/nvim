return {
  'vorhey/code-bridge.nvim',
  config = function()
    require('code-bridge').setup {
      provider = 'codex', -- 'claude' | 'codex' | 'gemini' (default 'claude')
      interactive = { use_telescope = true },
    }
    vim.keymap.set('n', '<leader>cf', '<cmd>CodeBridgeTmux<cr>', { desc = 'code-bridge single file' })
    vim.keymap.set('n', '<leader>ca', '<cmd>CodeBridgeTmuxAll<cr>', { desc = 'code-bridge all files' })
    vim.keymap.set('n', '<leader>ci', '<cmd>CodeBridgeTmuxInteractive<cr>', { desc = 'code-bridge interactive' })
  end,
}
