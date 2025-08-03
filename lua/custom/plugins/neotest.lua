---@diagnostic disable: missing-fields
return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'Issafalcon/neotest-dotnet',
    'marilari88/neotest-vitest',
    'alfaix/neotest-gtest',
    'nvim-neotest/neotest-go',
  },
  -- Lazy load options
  cmd = { 'Neotest' },
  keys = {
    { '<leader>nR', desc = 'Test: Run All Tests' },
    { '<leader>nr', desc = 'Test: Run Tests' },
    { '<leader>nt', desc = 'Test: Toggle Test Summary' },
    { '<leader>ns', desc = 'Test: Stop Test' },
    { '<leader>no', desc = 'Test: Open Test Output' },
  },
  config = function()
    require('neotest').setup {
      log_level = vim.log.levels.DEBUG,
      adapters = {
        require 'neotest-dotnet',
        require 'neotest-vitest',
        require 'neotest-go' {
          recursive_run = true,
        },
        require('neotest-gtest').setup {},
      },
    }
    -- neotest
    vim.api.nvim_set_keymap(
      'n',
      '<leader>nR',
      ':lua require("neotest").run.run({suite = true})<CR>',
      { desc = 'Test: Run All Tests', noremap = true, silent = true }
    )
    vim.api.nvim_set_keymap('n', '<leader>nr', ':lua require("neotest").run.run()<CR>', { desc = 'Test: Run Tests', noremap = true, silent = true })
    vim.api.nvim_set_keymap(
      'n',
      '<leader>nt',
      ':lua require("neotest").summary.toggle()<CR>',
      { desc = 'Test: Toggle Test Summary', noremap = true, silent = true }
    )
    vim.api.nvim_set_keymap('n', '<leader>ns', ':lua require("neotest").run.stop()<CR>', { desc = 'Test: Stop Test', noremap = true, silent = true })
    vim.api.nvim_set_keymap(
      'n',
      '<leader>no',
      ':lua require("neotest").output.open({ enter = true })<CR>',
      { desc = 'Test: Open Test Output', noremap = true, silent = true }
    )
  end,
}
