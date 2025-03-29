return {
  'sindrets/diffview.nvim',
  lazy = true,
  config = function()
    require('diffview').setup {
      enhanced_diff_hl = true,
    }
    vim.keymap.set('n', '<leader>gh', function()
      Snacks.picker.git_log_file {
        confirm = function(_, selected)
          if selected and selected.commit then
            vim.cmd('DiffviewOpen ' .. selected.commit .. '^!')
          end
        end,
      }
    end, { desc = 'git: log file' })
  end,
}
