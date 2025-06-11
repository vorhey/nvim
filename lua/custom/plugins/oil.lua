return {
  'stevearc/oil.nvim',
  config = function()
    ---@type oil.SetupOpts
    require('oil').setup {
      float = {
        padding = 0,
        max_height = 0.97,
      },
      keymaps = {
        ['gyy'] = {
          desc = 'copy filepath to system clipboard',
          callback = function()
            local oil = require 'oil'
            local entry = oil.get_cursor_entry()
            local dir = oil.get_current_dir()
            if not entry or not dir then
              return
            end
            local relpath = vim.fn.fnamemodify(dir, ':.')
            vim.fn.setreg('+', relpath .. entry.name)
          end,
        },
      },
    }
    vim.keymap.set('n', '<leader>e', function()
      require('oil').open_float()
    end, { desc = 'explorer' })
  end,
  -- Optional dependencies
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  lazy = false,
}
