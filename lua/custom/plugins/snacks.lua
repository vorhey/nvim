---@diagnostic disable: undefined-global
return {
  'folke/snacks.nvim',
  opts = {
    input = {},
    picker = {
      ui_select = true,
      layout = {
        layout = {
          box = 'horizontal',
          width = 0,
          height = 0.7,
          {
            box = 'vertical',
            border = 'rounded',
            title = '{title} {live} {flags}',
            { win = 'input', height = 1, border = 'bottom' },
            { win = 'list', border = 'none' },
          },
          { win = 'preview', title = '{preview}', border = 'rounded', width = 0.3 },
        },
      },
      win = {
        input = {
          keys = {
            ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
            ['<c-s>'] = { 'edit_vsplit', mode = { 'i', 'n' } },
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
      desc = 'smart find files',
    },
    {
      '<leader>fa',
      function()
        Snacks.picker.buffers()
      end,
      desc = 'buffers',
    },
    {
      '<leader>fg',
      function()
        Snacks.picker.grep()
      end,
      desc = 'grep',
    },
    {
      '<leader>fd',
      function()
        Snacks.picker.git_status()
      end,
      desc = 'git status',
    },
    {
      '<leader>fr',
      function()
        Snacks.picker.resume()
      end,
      desc = 'resume',
    },
    {
      '<leader>f.',
      function()
        Snacks.picker.recent { filter = { cwd = true } }
      end,
      desc = 'recent',
    },
    {
      '<leader>fh',
      function()
        Snacks.picker.help()
      end,
      desc = 'help pages',
    },
    {
      'gr',
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = 'references',
    },
    {
      'gd',
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = 'goto definition',
    },
    {
      '<leader>o',
      function()
        Snacks.bufdelete.other()
      end,
      desc = 'close others',
    },
    {
      '<leader>O',
      function()
        Snacks.bufdelete.delete()
      end,
      desc = 'close',
    },
    {
      '<leader>fl',
      function()
        Snacks.picker.highlights()
      end,
      desc = 'highlights',
    },
    {
      '<leader>fu',
      function()
        Snacks.picker.undo()
      end,
      desc = 'undo history',
    },
    {
      '<leader>f:',
      function()
        Snacks.picker.command_history()
      end,
      desc = 'command history',
    },
    {
      '<leader>fw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = 'Visual selection or word',
      mode = { 'n', 'x' },
    },
  },
}
