return {
  'sindrets/diffview.nvim',
  opts = {
    keymaps = {
      view = {
        { 'n', '<C-c>', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' } },
      },
      file_panel = {
        { 'n', '<C-c>', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' } },
      },
      file_history_panel = {
        { 'n', '<C-c>', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' } },
      },
    },
  },
  keys = {
    { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'git: history (file)' },
    { '<leader>gf', '<cmd>DiffviewFileHistory<cr>', desc = 'git: file history (repo)' },
    { '<leader>gv', ":'<,'>DiffviewFileHistory<cr>", desc = 'git: history (visual)', mode = 'v' },
    { '<leader>gc', '<cmd>DiffviewFileHistory --follow %<cr>', desc = 'git: commits (follow)' },
    { '<leader>gL', '<cmd>DiffviewFileHistory --all<cr>', desc = 'git: Log (all branches)' },
  },
}
