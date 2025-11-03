return {
  'selimacerbas/mermaid-playground.nvim',
  dependencies = { 'barrett-ruth/live-server.nvim', opts = {} },
  config = function()
    require('mermaid_playground').setup {}
  end,
}
