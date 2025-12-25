return {
  enabled = true,
  'vorhey/oldworld.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    local variant = 'light'
    if vim.env.TERM == 'foot' or vim.env.TERM_COLOR == 'dark' then
      variant = 'dark'
    end
    require('oldworld').setup {
      variant = variant,
    }
    vim.cmd.colorscheme 'oldworld'
  end,
}
