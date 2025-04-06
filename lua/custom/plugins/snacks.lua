---@diagnostic disable: undefined-global
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>ts'
        Snacks.toggle.inlay_hints():map '<leader>th'
        Snacks.toggle.diagnostics():map '<leader>tD'
        Snacks.toggle
          .new({
            id = 'format_on_save',
            name = 'Format on Save',
            get = function()
              return not vim.g.disable_autoformat
            end,
            set = function(state)
              vim.g.disable_autoformat = not state
            end,
          })
          :map '<leader>tf'
        Snacks.toggle
          .new({
            id = 'copilot',
            name = 'Copilot',
            get = function()
              return vim.g.copilot_enabled
            end,
            set = function()
              vim.g.copilot_enabled = not vim.g.copilot_enabled
            end,
          })
          :map '<leader>tc'
        Snacks.toggle
          .new({
            id = 'db_ui',
            name = 'DB UI',
            get = function()
              return vim.g.db_ui_open
            end,
            set = function()
              for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) == '' then
                  vim.api.nvim_buf_delete(buf, { force = true })
                end
              end
              vim.cmd 'DBUIToggle'
            end,
          })
          :map '<leader>td'
      end,
    })
  end,
  opts = {
    statuscolumn = {
      enabled = true,
    },
    words = {
      enabled = true,
    },
    dashboard = {
      preset = {
        header = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⣀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⠀⠀⠀  ⣐⣧⣾⣾⣿⣿⣿⣿⣿⣿⣷⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣤⣥⣤⣴⢶⣶⣶⣶⣶⠾⠞⠓⠂⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣻⣿⣿⣿⣿⣿⣿⢶⡿⣿⡷⣶⡂⠄⠀⠀⠀⣄⣔⣤⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀ ⠀⠀⠀⠀  ⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣍⣿⣿⣛⣻⡿⣿⡷⣶⢍⠢⡀⣀⣤⢲⡆⢹⢾⢸⠂⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠉⠛⣿⣎⢻⠞⣣⣄⡷⢿⠿⣼⢃⣓⢎⠆⠀⠀
⠀⠀⠀ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⠆⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⣟⢦⣶⣿⢝⠞⡨⣳⡿⢑⣹⠟⠁⠀⠀⠀
 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⢾⡻⣙⢔⢨⣧⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⣴⣟⣵⡿⣻⣕⢥⣾⢞⣵⡣⠞⠁⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣠⣶⢟⡭⡺⣝⣝⣾⡾⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣟⡿⣞⣿⡾⡿⣝⣼⡪⣟⣽⡾⠟⠁⠀ ⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⡠⣴⠟⣩⣾⠗⡩⣪⣾⡿⣻⡾⠛⣏⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣻⣯⣗⣯⣷⡟⣏⣧⡷⣟⣫⡵⠞⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⢀⡪⠞⠡⣚⡻⠥⡜⣮⣟⣾⢼⣿⡅⠀⢹⡸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⢿⡞⣿⣻⢼⢷⣛⣯⡷⠟⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⢠⣱⣍⣡⣁⡮⡷⢺⣟⢿⣷⣻⣮⣻⡿⣶⣤⣿⣿⣟⣿⣿⣿⣛⣻⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣧⣿⣷⣫⣿⢷⡟⢏⡙⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⣼⢶⣟⢼⡻⣺⣝⡷⣨⢓⠥⡟⣻⣾⣿⠿⠿⣷⣶⣶⣾⣿⣿⣿⣿⣯⣿⣿⣿⣿⣿⣯⣿⣿⣿⣟⡻⠹⣓⣺⣵⣾⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠘⠿⣗⡽⣵⡌⣝⡛⣷⡿⢿⣤⣿⣿⣷⣾⡿⢿⣿⣿⣿⣿⣿⣿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡯⣤⡷⡿⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠉⠙⠚⠛⠛⠿⠿⠿⠿⠿⠿⠟⠛⠛⠛⠛⠋⠉⠩⢗⢽⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠙⠋⠟⠋⠛⠛⡛⠛⠉⠓⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
]],
      },
      sections = {
        { section = 'header' },
        { section = 'startup' },
      },
    },
    input = {},
    picker = {
      ui_select = true,
      layouts = {
        select = { layout = { width = 0.5 } },
        default = { layout = { width = 0 } },
      },
      win = {
        input = {
          keys = {
            ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
            ['<c-s>'] = { 'edit_vsplit', mode = { 'i', 'n' } },
          },
        },
      },
    },
    lazygit = {
      enabled = true,
    },
    scope = {
      enabled = true,
    },
  },
  keys = {
    {
      '<leader>ff',
      function()
        Snacks.picker.smart { filter = { cwd = true } }
      end,
      desc = 'smart find files',
    },
    {
      '<leader>fa',
      function()
        Snacks.picker.buffers()
      end,
      desc = 'buffers',
    },
    {
      '<leader>fg',
      function()
        Snacks.picker.grep()
      end,
      desc = 'grep',
    },
    {
      '<leader>fd',
      function()
        Snacks.picker.git_status()
      end,
      desc = 'git status',
    },
    {
      '<leader>fr',
      function()
        Snacks.picker.resume()
      end,
      desc = 'resume',
    },
    {
      '<leader>f.',
      function()
        Snacks.picker.recent { filter = { cwd = true } }
      end,
      desc = 'recent',
    },
    {
      '<leader>fh',
      function()
        Snacks.picker.help()
      end,
      desc = 'help pages',
    },
    {
      'gr',
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = 'references',
    },
    {
      'gd',
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = 'goto definition',
    },
    {
      'gi',
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = 'goto implementation',
    },
    {
      '<leader>o',
      function()
        Snacks.bufdelete.other()
      end,
      desc = 'close others',
    },
    {
      '<leader>O',
      function()
        Snacks.bufdelete.delete()
      end,
      desc = 'close',
    },
    {
      '<leader>fl',
      function()
        Snacks.picker.highlights()
      end,
      desc = 'highlights',
    },
    {
      '<leader>fu',
      function()
        Snacks.picker.undo()
      end,
      desc = 'undo history',
    },
    {
      '<leader>f:',
      function()
        Snacks.picker.command_history()
      end,
      desc = 'command history',
    },
    {
      '<leader>fw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = 'visual selection or word',
      mode = { 'n', 'x' },
    },
    {
      '<leader>fs',
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = 'lsp symbols',
    },
    {
      '<leader>fn',
      function()
        Snacks.picker.notifications()
      end,
      desc = 'notifications',
    },
    {
      '<leader>gl',
      function()
        Snacks.lazygit()
      end,
      desc = 'git: lazy git',
    },
  },
}
