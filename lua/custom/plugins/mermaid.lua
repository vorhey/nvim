return {
  'selimacerbas/mermaid-playground.nvim',
  lazy = true,
  event = 'VeryLazy',
  dependencies = { 'barrett-ruth/live-server.nvim', opts = {} },
  config = function()
    require('mermaid_playground').setup {}
  end,
}
