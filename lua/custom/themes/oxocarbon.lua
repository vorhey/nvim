return {
  'nyoom-engineering/oxocarbon.nvim',
  enabled = false,
  config = function()
    vim.opt.background = 'dark' -- set this to dark or light
    vim.cmd.colorscheme 'oxocarbon'
  end,
  -- Add in any other configuration;
  --   event = foo,
  --   config = bar
  --   end,
}
