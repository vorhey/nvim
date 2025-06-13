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
      end,
    })
  end,
  opts = {
    image = {
      enabled = not vim.g.is_wsl,
    },
    statuscolumn = {
      enabled = true,
    },
    dashboard = {
      sections = {
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
      sources = {
        buffers = {
          preview = false,
          format = 'buffer',
          layout = {
            preset = 'dropdown',
            hidden = { 'preview' },
          },
          formatters = {
            file = {
              filename_only = true,
              truncate = 0,
            },
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
    words = {
      enabled = true,
    },
  },
  keys = {
    {
      '<leader>ff',
      function()
        Snacks.picker.smart {
          filter = { cwd = true },
          layout = {
            preset = 'dropdown',
            hidden = { 'preview' },
          },
        }
      end,
      desc = 'files',
    },
    {
      '<leader>fv',
      function()
        local start_pos = vim.fn.getpos 'v'
        local end_pos = vim.fn.getpos '.'
        local lines = vim.fn.getregion(start_pos, end_pos, { type = vim.fn.mode() })
        local search_term = table.concat(lines, '\n')
        Snacks.picker.files {
          filter = { cwd = true },
          search = search_term,
          layout = {
            preset = 'dropdown',
            hidden = { 'preview' },
          },
        }
      end,
      desc = 'files with selection',
      mode = { 'v' },
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
      '<leader>fs',
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = 'lsp symbols',
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
        local current_word = vim.fn.expand '<cword>'
        -- Try LSP definitions first
        Snacks.picker.lsp_definitions {
          on_close = function(picker)
            -- Check if picker had any results when closed
            if picker:count() == 0 then
              -- Fallback to grep for the word under cursor
              vim.schedule(function()
                Snacks.picker.grep { search = current_word }
              end)
            end
          end,
        }
      end,
      desc = 'goto definition (with grep fallback)',
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
      '<leader>fn',
      function()
        Snacks.picker.notifications()
      end,
      desc = 'notifications',
    },
    {
      '<leader>gl',
      function()
        Snacks.picker.git_log_file()
      end,
      desc = 'git: lazy git',
    },
  },
}
