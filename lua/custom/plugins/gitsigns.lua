return {
  'lewis6991/gitsigns.nvim',
  config = function()
    require('gitsigns').setup {
      numhl = true,
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
        vim.keymap.set('n', '<leader>gR', gs.reset_buffer, { desc = 'git: Restore' })
        vim.keymap.set('n', '<leader>gr', gs.reset_hunk, { desc = 'git: Reset Hunk' })
        vim.keymap.set('n', '<leader>gp', gs.preview_hunk, { desc = 'git: Preview Hunk' })
        vim.keymap.set('n', '<leader>gb', function()
          gs.blame_line { full = true }
        end, { desc = 'git: Blame line' })
        vim.keymap.set('n', '<leader>gB', gs.toggle_current_line_blame, { desc = 'git: Toggle Blame' })
        vim.keymap.set('n', ']c', function()
          gs.nav_hunk('next', {
            target = 'all',
          })
        end, { desc = 'git: Next Hunk' })
        vim.keymap.set('n', '[c', function()
          gs.nav_hunk('prev', {
            target = 'all',
          })
        end, { desc = 'git: Previous Hunk' })
        vim.keymap.set('n', '<leader>gd', gs.diffthis, { desc = 'git: Toggle diff' })
        vim.keymap.set('n', '<leader>gD', function()
          vim.ui.input({ prompt = 'Branch: ' }, function(branch)
            if branch then
              gs.diffthis(branch, { vertical = true })
            end
          end)
        end, { desc = 'Git: Diff against branch' })
      end,
    }
  end,
}
