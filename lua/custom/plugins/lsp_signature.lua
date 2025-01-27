return {
  'ray-x/lsp_signature.nvim',
  event = 'VeryLazy',
  config = function()
    local cfg = {
      hint_prefix = {
        above = '↙ ', -- when the hint is on the line above the current line
        current = '← ', -- when the hint is on the same line
        below = '↖ ', -- when the hint is on the line below the current line
      },
      floating_window = false,
      fix_pos = true,
      hint_scheme = 'Comment',
      hint_enable = true,
      toggle_key_flip_floatwin_setting = true,
      handler_opts = { border = 'rounded' },
    }

    require('lsp_signature').setup(cfg)
  end,
}
