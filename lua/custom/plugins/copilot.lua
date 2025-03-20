return {
  'github/copilot.vim',
  init = function()
    -- disable copilot
    vim.g.copilot_enabled = false
  end,
  config = function()
    -- autocomplete keybinding
    vim.keymap.set('i', '<C-e>', 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false,
    })
    vim.g.copilot_no_tab_map = true
    -- toggle copilot
    local toggle_copilot = function()
      vim.g.copilot_enabled = not vim.g.copilot_enabled
    end
    vim.keymap.set('n', '<leader>tc', toggle_copilot, { silent = true, noremap = true, desc = 'toggle copilot' })
  end,
}
