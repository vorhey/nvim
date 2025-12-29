return {
  'olimorris/codecompanion.nvim',
  enabled = true,
  lazy = true,
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
      display = {
        chat = {
          window = {
            full_height = false,
            width = 0.5,
          },
          show_reasoning = false,
        },
      },
      extensions = { history = { enabled = true } },
      strategies = {
        chat = {
          name = 'copilot',
          model = 'gpt-4.1',
        },
        -- chat = {
        --   adapter = 'ollama',
        --   model = 'qwen3-coder:480b-cloud',
        -- },
      },
      adapters = {
        http = {
          ollama = function()
            return require('codecompanion.adapters').extend('ollama', {
              opts = {
                vision = true,
              },
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
      web_search_engine = {
        provider = 'tavily',
      },
    }
    vim.keymap.set({ 'n', 'v' }, '<C-b>', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true, desc = 'code companion: actions' })
    vim.keymap.set({ 'n', 'v' }, 'g;', '<cmd>CodeCompanionChat Toggle<cr>', { noremap = true, silent = true, desc = 'code companion: toggle' })
    vim.keymap.set('v', 'ga', '<cmd>CodeCompanionChat Add<cr>', { noremap = true, silent = true, desc = 'code companion: chat add' })
    vim.cmd [[cab cc CodeCompanion]]
  end,
}
