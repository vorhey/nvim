return {
  'nvim-telescope/telescope.nvim',
  enabled = false,
  event = 'VimEnter',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    {
      's1n7ax/nvim-window-picker',
      name = 'window-picker',
      event = 'VeryLazy',
      version = '2.*',
    },
    'debugloop/telescope-undo.nvim',
    {
      'tomasky/bookmarks.nvim',
      event = 'VimEnter',
      config = function()
        require('bookmarks').setup {
          on_attach = function()
            local bm = require 'bookmarks'
            vim.keymap.set('n', '<leader>bb', bm.bookmark_toggle, { desc = 'Bookmark: Toggle' }) -- add or remove bookmark at current line
            vim.keymap.set('n', '<leader>be', bm.bookmark_ann, { desc = 'Bookmark: Edit' }) -- add or edit mark annotation at current line
            vim.keymap.set('n', '<leader>bc', bm.bookmark_clean, { desc = 'Bookmark: Clean' }) -- clean all marks in local buffer
            vim.keymap.set('n', '<leader>bn', bm.bookmark_next, { desc = 'Bookmark: Next' }) -- jump to next mark in local buffer
            vim.keymap.set('n', '<leader>bp', bm.bookmark_prev, { desc = 'Bookmark: Prev' }) -- jump to previous mark in local buffer
            vim.keymap.set('n', '<leader>bs', bm.bookmark_list, { desc = 'Bookmark: List' }) -- show marked file list in quickfix window
            vim.keymap.set('n', '<leader>bd', bm.bookmark_clear_all, { desc = 'Bookmark: Delete all' }) -- removes all bookmarks
          end,
        }
      end,
    },
  },
  config = function()
    local window_picker = require 'window-picker'
    window_picker.setup {
      hint = 'floating-big-letter',
      filter_rules = {
        autoselect_one = true,
        include_current_win = true,
        bo = {
          filetype = { 'NvimTree', 'neo-tree', 'notify', 'fidget', 'incline', 'noice-lsp' },
          buftype = { 'terminal' },
        },
      },
    }

    local function custom_get_selection_window(picker, entry)
      local picked_window_id = window_picker.pick_window() or vim.api.nvim_get_current_win()
      return picked_window_id
    end

    require('telescope').setup {
      defaults = {
        sorting_strategy = 'ascending',
        file_ignore_patterns = {
          'node_modules/.*',
          'public',
          'bin/.*',
          'obj/.*',
          'build/.*',
          'dist/.*',
          'target/.*',
          'out/.*',
          'vendor/.*',
          '.git/.*',
          '.vscode/.*',
          '.idea/.*',
          '.next/.*',
          'gradle/.*',
          'app/build/.*',
          '%.o$',
          '%.a$',
          '%.log$',
          '%.class$',
          '%.pdf$',
          '%.jpg$',
          '%.png$',
          '%.ttf$',
          '%.ico$',
        },
        get_selection_window = custom_get_selection_window,
        layout_strategy = 'horizontal',
        layout_config = {
          horizontal = {
            prompt_position = 'top',
            height = 0.6,
          },
        },
        previewer = true,
      },
      extensions = {
        undo = {},
        bookmarks = {},
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case',
        },
      },
    }

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
    pcall(require('telescope').load_extension, 'undo')
    pcall(require('telescope').load_extension, 'bookmarks')

    local builtin = require 'telescope.builtin'

    local grep_open_files = function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end

    local find_hidden_files = function()
      builtin.find_files {
        prompt_title = 'Find Hiden Files',
        hidden = true,
        no_ignore = true,
        file_ignore_patterns = {
          'node_modules/.*',
          '.git/.*',
          '.vscode/.*',
          '.idea/.*',
          '%.o$',
          '%.a$',
          '%.log$',
          '%.class$',
          '%.pdf$',
          '%.jpg$',
          '%.png$',
          '%.ttf$',
          '%.ico$',
        },
        sorter = require('telescope').extensions.fzf.native_fzf_sorter {
          fuzzy = true,
          override_file_sorter = true,
          case_mode = 'smart_case',
          sort_function = function(a, b)
            return require('telescope.extensions.fzf').prefilter_sort(a, b, {
              exact = 100, -- higher weight for exact matches
              start = 95, -- higher weight for matches at start
              length = -20, -- shorter matches ranked higher
              alpha = 0.1, -- factor for case sensitivity (lower is more sensitive)
            })
          end,
        },
      }
    end

    -- Keybindings
    vim.keymap.set('n', '<leader>fb', '<cmd>Telescope bookmarks list<cr>', { desc = 'Find: Bookmarks' })
    vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = 'Find: String' })
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find: Files' })
    vim.keymap.set('n', '<leader>fF', find_hidden_files, { desc = 'Find: Hidden Files' })
    vim.keymap.set('n', '<leader>ft', builtin.builtin, { desc = 'Find: Select Telescope' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Find: Grep' })
    vim.keymap.set('n', '<leader>fd', builtin.git_status, { desc = 'Find: Git Diff' })
    vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = 'Find: Resume' })
    vim.keymap.set('n', '<leader>fo', builtin.buffers, { desc = 'Find: Opened Buffers' })
    vim.keymap.set('n', '<leader>fu', '<cmd>Telescope undo<cr>', { desc = 'Find: Undo Tree' })
    vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = 'Find: Recent Files' })
    vim.keymap.set('n', '<leader>f/', grep_open_files, { desc = 'Find: In Open Files' })
    vim.keymap.set('v', '<leader>f', 'y:Telescope live_grep default_text=<C-r>"<CR>', { desc = 'Find: Grep Selected Text' })
  end,
}
