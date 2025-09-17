return {
  'vorhey/harvgate',
  enabled = true,
  lazy = true,
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('harvgate').setup {
      provider = 'claude', -- or "copilot"
      width = 70,
      height = 10,
      keymaps = {
        new_chat = '<C-g>',
        toggle_zen_mode = '<C-r>',
        copy_code = '<C-y>',
      },
      providers = {
        claude = {
          cookie = os.getenv 'CLAUDE_COOKIE',
          organization_id = nil,
          model = 'claude-opus-4-1-20250805',
        },
        copilot = {
          -- authentication is resolved via copilot.lua; override if you need to
          model = 'gpt-4o-mini',
          temperature = 0.2,
        },
      },
    }

    vim.keymap.set('n', '<leader>hh', ':HarvgateChat<CR>', { desc = 'harvgate toggle chat', silent = true })
    vim.keymap.set('n', '<leader>hc', ':HarvgateListChats<CR>', { desc = 'harvgate open chats', silent = true })
    vim.keymap.set('n', '<leader>ha', ':HarvgateAddBuffer<CR>', { desc = 'harvgate add buffer', silent = true })
  end,
}
