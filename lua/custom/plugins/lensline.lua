return {
  'oribarilan/lensline.nvim',
  event = 'LspAttach',
  config = function()
    require('lensline').setup {
      profiles = {
        {
          name = 'minimal',
          style = {
            placement = 'inline',
            prefix = '',
            -- render = "focused", optionally render lenses only for focused function
          },
        },
      },
    }
  end,
}
