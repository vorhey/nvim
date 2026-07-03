return {
  'lionyxml/gitlineage.nvim',
  event = 'VeryLazy',
  config = function()
    require('gitlineage').setup()
  end,
}
