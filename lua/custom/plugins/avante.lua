return {
  'yetone/avante.nvim',
  build = vim.fn.has 'win32' ~= 0 and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false' or 'make',
  event = 'VeryLazy',
  version = false,
  opts = {
    mode = 'legacy',
    provider = 'gemini',
    providers = {
      gemini = {
        model = 'gemini-2.5-flash',
      },
    },
    selection = { hint_display = 'none' },
    selector = { provider = 'snacks' },
    input = { provider = 'snacks', provider_opts = { title = 'Avante Input', icon = ' ' } },
    windows = {
      width = 40,
      sidebar_header = { enabled = false },
      input = { prefix = '' },
      edit = { border = 'rounded' },
      ask = { border = 'rounded' },
    },
  },
  config = function(_, opts)
    local PromptInput = require 'avante.ui.prompt_input'
    if not PromptInput._no_hint then
      local original_open = PromptInput.open
      function PromptInput:open()
        original_open(self)
        if self.winid and vim.api.nvim_win_is_valid(self.winid) then
          vim.api.nvim_set_option_value('winblend', 0, { win = self.winid })
        end
        if self.shortcuts_hints_winid and vim.api.nvim_win_is_valid(self.shortcuts_hints_winid) then
          vim.api.nvim_win_close(self.shortcuts_hints_winid, true)
          self.shortcuts_hints_winid = nil
        end
      end
      function PromptInput:show_shortcuts_hints() end
      ---@diagnostic disable-next-line: inject-field
      PromptInput._no_hint = true
    end

    require('avante').setup(opts)
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = { file_types = { 'markdown', 'Avante' } },
      ft = { 'markdown', 'Avante' },
    },
  },
}
