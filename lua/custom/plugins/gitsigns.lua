-- Here is a more advanced example where we pass configuration
-- options to `gitsigns.nvim`. This is equivalent to the following Lua:
--    require('gitsigns').setup({ ... })
--
-- See `:help gitsigns` to understand what the configuration keys do
return {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  config = function()
    require('gitsigns').setup {
      on_attach = function(bufnr)
        local function map(mode, lhs, rhs, opts)
          opts = vim.tbl_extend('force', { noremap = true, silent = true }, opts or {})
          vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
        end
        local gitsigns = require 'gitsigns'
        local wk = require 'which-key'
        wk.add({
          -- Actions
          { '<leader>hr', gitsigns.reset_hunk, desc = 'Reset hunk', mode = { 'n', 'v' } },
          { '<leader>hR', gitsigns.reset_buffer, desc = 'Restore' },
          { '<leader>hp', gitsigns.preview_hunk, desc = 'Preview hunk' },
          { '<leader>hb', gitsigns.blame_line { full = true }, desc = 'Blame line' },
          { '<leader>hB', gitsigns.toggle_current_line_blame, desc = 'Toggle line blame' },
          { '<leader>hd', "<cmd>lua require('gitsigns').diffthis() vim.api.nvim_command('wincmd h')<CR>", desc = 'Diff view' },
        }, { buffer = bufnr })
      end,
    }
  end,
}
