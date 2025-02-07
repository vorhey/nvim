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
        vim.keymap.set('n', '<leader>hR', gs.reset_buffer, { desc = 'Git: Restore' })
        vim.keymap.set('n', '<leader>hr', gs.reset_hunk, { desc = 'Git: Reset Hunk' })
        vim.keymap.set('n', '<leader>hp', gs.preview_hunk, { desc = 'Git: Preview Hunk' })
        vim.keymap.set('n', '<leader>hb', function()
          gs.blame_line { full = true }
        end, { desc = 'Git: Blame line' })
        vim.keymap.set('n', '<leader>hB', gs.toggle_current_line_blame, { desc = 'Git: Toggle Blame' })
        vim.keymap.set('n', ']c', function()
          gs.nav_hunk('next', {
            target = 'all',
          })
        end, { desc = 'Git: Next Hunk' })
        vim.keymap.set('n', '[c', function()
          gs.nav_hunk('prev', {
            target = 'all',
          })
        end, { desc = 'Git: Previous Hunk' })
        vim.keymap.set('n', '<leader>hd', gs.diffthis, { desc = 'Git: Toggle diff' })
        vim.keymap.set('n', '<leader>hD', function()
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
