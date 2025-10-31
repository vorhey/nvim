return {
  'sindrets/diffview.nvim',
  opts = {
    keymaps = {
      view = {
        { 'n', '<C-c>', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' } },
        { 'n', '<leader>co', false },
        { 'n', '<leader>ct', false },
        { 'n', '<leader>cb', false },
        { 'n', '<leader>ca', false },
        { 'n', '<leader>Go', '<Cmd>DiffviewConflictChooseOurs<CR>', { desc = 'Choose OURS (conflict)' } },
        { 'n', '<leader>Gt', '<Cmd>DiffviewConflictChooseTheirs<CR>', { desc = 'Choose THEIRS (conflict)' } },
        { 'n', '<leader>Gb', '<Cmd>DiffviewConflictChooseBase<CR>', { desc = 'Choose BASE (conflict)' } },
        { 'n', '<leader>Ga', '<Cmd>DiffviewConflictChooseAll<CR>', { desc = 'Choose ALL (conflict)' } },
        {
          'n',
          '<leader>gH',
          function()
            local diff_keys = {
              { 'do', 'Get changes from other window into current window (diff obtain)' },
              { 'dp', 'Put changes from current window into other window (diff put)' },
              { ']h', 'Jump to next change' },
              { '[h', 'Jump to previous change' },
              { 'zc', 'Fold unchanged text' },
              { 'zo', 'Open fold of unchanged text' },
              { 'zM', 'Close all folds' },
              { 'zR', 'Open all folds' },
              { ':diffupdate', 'Re-scan the files for changes' },
              { ':diffget', "Like 'do' but can specify buffer number" },
              { ':diffput', "Like 'dp' but can specify buffer number" },
              { ':set diffopt=...', 'Change diff options' },
            }

            local lines = { '# Neovim Built-in Diff Keybindings', '' }
            for _, v in ipairs(diff_keys) do
              table.insert(lines, string.format('%-15s %s', v[1], v[2]))
            end

            vim.lsp.util.open_floating_preview(lines, 'markdown', {
              border = 'rounded',
              width = 80,
            })
          end,
          { desc = 'Help for diff keybindings' },
        },
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
    {
      '<leader>gC',
      function()
        local commit = vim.fn.input 'Commit hash: '
        if commit ~= '' then
          vim.cmd('DiffviewOpen ' .. commit .. ' -- %')
        end
      end,
      desc = 'git: compare commit vs current',
    },
  },
}
