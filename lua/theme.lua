-- Nvim asks the terminal for its background color (OSC 11) before loading
-- this config and sets 'background' from the answer.
local function apply(bg)
  local name = bg == 'light' and 'oldworld' or 'ember'
  if vim.g.colors_name == name then
    return
  end
  if name == 'oldworld' then
    require('oldworld').setup {
      variant = 'light',
    }
    vim.cmd.colorscheme 'oldworld'
    vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { bg = 'none' })
  else
    vim.cmd.colorscheme 'ember'
  end
end

return {
  { 'vorhey/oldworld.nvim', lazy = true },
  {
    'vorhey/ember.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      apply(vim.o.background)

      local group = vim.api.nvim_create_augroup('theme-follow-terminal', {})
      -- Follow the terminal when its background changes. Nvim's own handler
      -- for this is dropped once a colorscheme sets 'background'.
      vim.api.nvim_create_autocmd('TermResponse', {
        group = group,
        nested = true,
        callback = function(ev)
          local r, g, b = ev.data.sequence:match '^\027%]11;rgba?:(%x+)/(%x+)/(%x+)'
          if not r then
            return
          end
          local function channel(c)
            return tonumber(c, 16) / (16 ^ #c - 1)
          end
          local luminance = 0.299 * channel(r) + 0.587 * channel(g) + 0.114 * channel(b)
          apply(luminance < 0.5 and 'dark' or 'light')
        end,
      })
      -- Terminals without theme-change notifications (mode 2031): ask again
      -- on focus.
      vim.api.nvim_create_autocmd('FocusGained', {
        group = group,
        callback = function()
          vim.api.nvim_ui_send '\027]11;?\007'
        end,
      })
    end,
  },
}
