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
  end,
}
