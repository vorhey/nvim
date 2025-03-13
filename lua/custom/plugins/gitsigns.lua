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
        vim.keymap.set('n', '<leader>gR', gs.reset_buffer, { desc = 'git: restore' })
        vim.keymap.set('n', '<leader>gr', gs.reset_hunk, { desc = 'git: reset hunk' })
        vim.keymap.set('n', '<leader>gp', gs.preview_hunk, { desc = 'git: preview hunk' })
        vim.keymap.set('n', '<leader>gb', function()
          gs.blame_line { full = true }
        end, { desc = 'git: blame line' })
        vim.keymap.set('n', '<leader>gB', gs.toggle_current_line_blame, { desc = 'git: toggle blame' })
        vim.keymap.set('n', ']c', function()
          gs.nav_hunk('next', {
            target = 'all',
          })
        end, { desc = 'git: next hunk' })
        vim.keymap.set('n', '[c', function()
          gs.nav_hunk('prev', {
            target = 'all',
          })
        end, { desc = 'git: previous hunk' })
        vim.keymap.set('n', '<leader>gd', gs.diffthis, { desc = 'git: toggle diff' })
        Snacks.toggle({
          name = 'Diffview',
          get = function()
            return require('diffview.lib').get_current_view() ~= nil
          end,
          set = function(state)
            vim.cmd('Diffview' .. (state and 'Open' or 'Close'))
          end,
        }):map '<leader>gt'
        vim.keymap.set('n', '<leader>gD', function()
          vim.ui.input({ prompt = 'Branch: ' }, function(branch)
            if branch then
              gs.diffthis(branch, { vertical = true })
            end
          end)
        end, { desc = 'git: diff against branch' })
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
