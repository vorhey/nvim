return {
  'ibhagwan/fzf-lua',
  config = function()
    -- vars
    local fzf = require 'fzf-lua'
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
    vim.keymap.set('n', '<leader>f:', fzf.command_history, { desc = 'Find: Command History' })
    vim.keymap.set('n', '<leader>ff', filtered_files, { desc = 'Find: Files' })
    vim.keymap.set('n', '<leader>fd', fzf.git_status, { desc = 'Find: Git' })
    vim.keymap.set('n', '<leader>fg', filtered_grep, { desc = 'Find: LiveGrep (root)' })
    vim.keymap.set('n', '<leader>/', fzf.live_grep, { desc = 'Find: LiveGrep' })
    vim.keymap.set('n', '<leader>fw', fzf.grep_cword, { desc = 'Find: Grep Current Word' })
    vim.keymap.set('n', '<leader>fW', fzf.grep_cWORD, { desc = 'Find: Grep Current Word' })
    vim.keymap.set('n', '<leader>f.', fzf.oldfiles, { desc = 'Find: Old files' })
    vim.keymap.set('n', '<leader>fa', fzf.buffers, { desc = 'Find: Buffers' })
    vim.keymap.set('n', '<leader>fr', fzf.resume, { desc = 'Find: Resume' })
    vim.keymap.set('v', '<leader>f', fzf.grep_visual, { desc = 'Find: Grep Selection' })

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
      lsp = {
        jump_to_single_result = true, -- automatically jump if there is only one result
      },
      grep = {
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
