return {
  'olimorris/codecompanion.nvim',
  keys = {
    { '<C-b>', mode = { 'n', 'v' } },
    { 'g;', mode = { 'n', 'v' } },
    { 'ga', mode = 'v' },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'ravitemer/codecompanion-history.nvim',
    { 'MeanderingProgrammer/render-markdown.nvim', ft = { 'markdown', 'codecompanion' } },
  },
  config = function()
    require('codecompanion').setup {
      extensions = { history = { enabled = true } },
      strategies = {
        chat = {
          adapter = 'ollama',
          model = 'qwen3-coder:480b-cloud',
        },
      },
      adapters = {
        http = {
          ollama = function()
            return require('codecompanion.adapters').extend('ollama', {
              env = {
                url = 'https://ollama.com',
                api_key = 'OLLAMA_API_KEY',
              },
              headers = {
                ['Content-Type'] = 'application/json',
                ['Authorization'] = 'Bearer ${api_key}',
              },
              parameters = {
                sync = true,
              },
            })
          end,
        },
      },
    }
    vim.keymap.set({ 'n', 'v' }, '<C-b>', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true, desc = 'code companion: actions' })
    vim.keymap.set({ 'n', 'v' }, 'g;', '<cmd>CodeCompanionChat Toggle<cr>', { noremap = true, silent = true, desc = 'code companion: toggle' })
    vim.keymap.set('v', 'ga', '<cmd>CodeCompanionChat Add<cr>', { noremap = true, silent = true, desc = 'code companion: chat add' })
    vim.cmd [[cab cc CodeCompanion]]
  end,
}
