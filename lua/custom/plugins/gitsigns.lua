return {
  'lewis6991/gitsigns.nvim',
  event = 'VeryLazy',
  config = function()
    require('gitsigns').setup {
      -- numhl = true,
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
      signs_staged = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
      },
      on_attach = function(buffer)
        local gs = require 'gitsigns'
        vim.keymap.set('n', '<leader>gR', gs.reset_buffer, { buffer = buffer, desc = 'git: restore' })
        vim.keymap.set('n', '<leader>gr', gs.reset_hunk, { buffer = buffer, desc = 'git: reset hunk' })
        vim.keymap.set('n', '<leader>gp', gs.preview_hunk, { buffer = buffer, desc = 'git: preview hunk' })
        vim.keymap.set('n', '<leader>gb', function()
          gs.blame_line { full = true }
        end, { buffer = buffer, desc = 'git: blame line' })
        vim.keymap.set('n', '<leader>gB', gs.toggle_current_line_blame, { buffer = buffer, desc = 'git: toggle blame' })
        vim.keymap.set('n', ']h', function()
          gs.nav_hunk('next', {
            target = 'all',
          })
        end, { buffer = buffer, desc = 'git: next hunk' })
        vim.keymap.set('n', '[h', function()
          gs.nav_hunk('prev', {
            target = 'all',
          })
        end, { buffer = buffer, desc = 'git: previous hunk' })
        vim.keymap.set('n', '<leader>gH', function()
          local diff_keys = {
            { 'do', 'Get changes from other window into current window (diff obtain)' },
            { 'dp', 'Put changes from current window into other window (diff put)' },
            { ']h', 'Jump to next change' },
            { '[h', 'Jump to previous change' },
            { 'ga', 'Accept inline edit (codecompanion)' },
            { 'gr', 'Reject inline edit (codecompanion)' },
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
        end, { buffer = buffer, desc = 'git: help for diff keybindings' })
        vim.keymap.set('n', '<leader>gd', gs.diffthis, { buffer = buffer, desc = 'git: toggle diff' })
        vim.keymap.set('n', '<leader>gD', function()
          vim.ui.input({ prompt = 'Branch: ' }, function(branch)
            if branch then
              gs.diffthis(branch, { vertical = true })
            end
          end)
        end, { buffer = buffer, desc = 'git: diff against branch' })
        vim.opt.diffopt = {
          'internal',
          'filler',
          'closeoff',
          'context:12',
          'algorithm:histogram',
          'linematch:200',
          'indent-heuristic',
        }
      end,
    }
  end,
}
