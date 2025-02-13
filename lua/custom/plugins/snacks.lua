---@diagnostic disable: undefined-global
return {
  'folke/snacks.nvim',
  opts = {
    picker = {
      -- your picker configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      layout = {
        layout = {
          box = 'horizontal',
          width = 0.95,
          height = 0.7,
          {
            box = 'vertical',
            border = 'rounded',
            title = '{title} {live} {flags}',
            { win = 'input', height = 1, border = 'bottom' },
            { win = 'list', border = 'none' },
          },
          { win = 'preview', title = '{preview}', border = 'rounded', width = 0.25 },
        },
      },
      win = {
        input = {
          keys = {
            ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
          },
        },
      },
    },
  },
  keys = {
    {
      '<leader>ff',
      function()
        Snacks.picker.smart { filter = { cwd = true } }
      end,
      desc = 'Smart Find Files',
    },
    {
      '<leader>fa',
      function()
        Snacks.picker.buffers()
      end,
      desc = 'Buffers',
    },
    {
      '<leader>fg',
      function()
        Snacks.picker.grep()
      end,
      desc = 'Grep',
    },
    {
      '<leader>fd',
      function()
        Snacks.picker.git_status()
      end,
      desc = 'Git Status',
    },
    {
      '<leader>fr',
      function()
        Snacks.picker.resume()
      end,
      desc = 'Resume',
    },
    {
      '<leader>f.',
      function()
        Snacks.picker.recent()
      end,
      desc = 'Recent',
    },
    {
      '<leader>fh',
      function()
        Snacks.picker.help()
      end,
      desc = 'Help Pages',
    },
    {
      'gr',
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = 'References',
    },
    {
      'gd',
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = 'Goto Definition',
    },
  },
}
