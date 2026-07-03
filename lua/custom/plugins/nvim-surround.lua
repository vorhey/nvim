return {
  'kylechui/nvim-surround',
  dependencies = {
    {
      'gregorias/nvim-surround-wk',
      config = true,
    },
  },
  version = '*', -- Use for stability; omit to use `main` branch for the latest features
  event = 'VeryLazy',
  config = function()
    vim.g.nvim_surround_no_normal_mappings = true
    vim.g.nvim_surround_no_visual_mappings = true
    vim.g.nvim_surround_no_insert_mappings = true

    require('nvim-surround').setup {}

    vim.keymap.set('n', 's', '<Plug>(nvim-surround-normal)', { desc = 'Add surrounding (normal)' })
    vim.keymap.set('x', 'S', '<Plug>(nvim-surround-visual)', { desc = 'Add surrounding (visual)' })
    vim.keymap.set('n', 'ds', '<Plug>(nvim-surround-delete)', { desc = 'Delete surrounding' })
    vim.keymap.set('n', 'cs', '<Plug>(nvim-surround-change)', { desc = 'Change surrounding' })
  end,
}
