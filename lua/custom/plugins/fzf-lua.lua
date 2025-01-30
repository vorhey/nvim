return {
  'ibhagwan/fzf-lua',
  config = function()
    -- vars
    local fzf = require 'fzf-lua'
    local config = fzf.config
    local actions = fzf.actions
    local utils = require 'utils'

    -- helper functions
    local function get_fd_excludes()
      local excludes = ''
      for _, pattern in ipairs(utils.ignore_patterns) do
        excludes = excludes .. '--exclude ' .. pattern .. ' '
      end
      return excludes
    end
    local function filtered_files()
      fzf.files {
        fd_opts = '--color=never --type f --hidden --follow ' .. get_fd_excludes(),
      }
    end
    local function filtered_grep()
      local exclude_patterns = ''
      for _, pattern in ipairs(utils.ignore_patterns) do
        exclude_patterns = exclude_patterns .. string.format('-g "!%s/" ', pattern)
      end

      fzf.live_grep {
        rg_opts = '--column --line-number --hidden --follow --smart-case ' .. exclude_patterns,
      }
    end

    -- keybindings
    config.defaults.keymap.fzf['ctrl-u'] = 'half-page-up'
    config.defaults.keymap.fzf['ctrl-d'] = 'half-page-down'
    vim.keymap.set('n', '<leader>f:', fzf.command_history, { desc = 'find: command history' })
    vim.keymap.set('n', '<leader>ff', filtered_files, { desc = 'find: files' })
    vim.keymap.set('n', '<leader>fd', fzf.git_status, { desc = 'find: git' })
    vim.keymap.set('n', '<leader>fg', filtered_grep, { desc = 'find: livegrep' })
    vim.keymap.set('n', '<leader>fw', fzf.grep_cword, { desc = 'find: grep current word' })
    vim.keymap.set('n', '<leader>fW', fzf.grep_cWORD, { desc = 'find: grep current word' })
    vim.keymap.set('n', '<leader>f.', fzf.oldfiles, { desc = 'find: old files' })
    vim.keymap.set('n', '<leader>fa', fzf.buffers, { desc = 'find: buffers' })
    vim.keymap.set('n', '<leader>fr', fzf.resume, { desc = 'find: resume' })
    vim.keymap.set('n', '<leader>fm', fzf.marks, { desc = 'find: marks' })
    vim.keymap.set('v', '<leader>f', fzf.grep_visual, { desc = 'find: grep selection' })

    vim.keymap.set('n', 'gr', function()
      fzf.lsp_references { jump_to_single_result = true, ignore_current_line = true }
    end, { desc = 'Find: LSP References' })

    vim.keymap.set('n', 'gd', function()
      fzf.lsp_definitions { jump_to_single_result = true, ignore_current_line = true }
    end, { desc = 'Find: LSP Definitions' })

    vim.keymap.set('n', 'gI', function()
      fzf.lsp_implementations { jump_to_single_result = true, ignore_current_line = true }
    end, { desc = 'Find: LSP Definitions' })

    -- fzf setup
    fzf.setup {
      actions = {
        files = {
          ['enter'] = actions.file_edit_or_qf,
          ['alt-s'] = actions.file_vsplit,
        },
      },
      lsp = {
        jump_to_single_result = true, -- automatically jump if there is only one result
      },
      fzf_opts = {
        ['--no-scrollbar'] = true,
      },
      grep = {
        actions = {
          ['alt-i'] = { actions.toggle_ignore },
          ['alt-h'] = { actions.toggle_hidden },
        },
      },
      files = {
        actions = {
          ['alt-i'] = { actions.toggle_ignore },
          ['alt-h'] = { actions.toggle_hidden },
        },
      },
      winopts = {
        preview = {
          vertical = 'up:40%',
          layout = 'vertical',
        },
      },
    }
  end,
}
