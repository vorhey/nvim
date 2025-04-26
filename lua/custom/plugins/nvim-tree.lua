return {
  'nvim-tree/nvim-tree.lua',
  event = 'VeryLazy',
  config = function()
    local api = require 'nvim-tree.api'
    require('nvim-tree').setup {
      on_attach = function(bufnr)
        local opts = { buffer = bufnr }
        api.config.mappings.default_on_attach(bufnr)
        -- function for left to assign to keybindings
        local lefty = function()
          local node_at_cursor = api.tree.get_node_under_cursor()
          -- if it's a node and it's open, close
          if node_at_cursor.nodes and node_at_cursor.open then
            api.node.open.edit()
            -- else left jumps up to parent
          else
            api.node.navigate.parent()
          end
        end
        -- function for right to assign to keybindings
        local righty = function()
          local node_at_cursor = api.tree.get_node_under_cursor()
          -- if it's a closed node, open it
          if node_at_cursor.nodes and not node_at_cursor.open then
            api.node.open.edit()
          elseif not node_at_cursor.nodes then
            api.node.open.edit()
          end
        end
        vim.keymap.set('n', 'h', lefty, opts)
        vim.keymap.set('n', 'l', righty, opts)
      end,
      filters = {
        dotfiles = false,
      },
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = true,
      hijack_unnamed_buffer_when_opening = false,
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      view = {
        adaptive_size = false,
        side = 'left',
        relativenumber = true,
        float = {
          enable = true,
          open_win_config = function()
            local screen_w = vim.opt.columns:get()
            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
            return {
              border = 'none',
              relative = 'editor',
              row = 0,
              col = 0,
              width = screen_w,
              height = screen_h,
            }
          end,
        },
      },
      git = {
        enable = true,
        ignore = false,
      },
      filesystem_watchers = {
        enable = true,
      },
      actions = {
        open_file = {
          resize_window = true,
        },
      },
      modified = {
        enable = true,
      },
      renderer = {
        root_folder_label = false,
        highlight_git = true,
        highlight_opened_files = 'none',
        highlight_modified = 'icon',

        indent_markers = {
          enable = true,
        },

        icons = {
          web_devicons = {
            file = { color = false },
          },
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
            modified = true,
          },

          glyphs = {
            default = '󰈚',
            symlink = '',
            folder = {
              default = '',
              empty = '',
              empty_open = '',
              open = '',
              symlink = '',
              symlink_open = '',
              arrow_open = '',
              arrow_closed = '',
            },
            git = {
              unstaged = '󱇧',
              staged = '󰈖',
              unmerged = '',
              renamed = '󰬲',
              untracked = '󰈮',
              deleted = '󰮘',
              ignored = '󰘓',
            },
            modified = '●',
          },
        },
      },
    }
    -- Add autocommand to close nvim-tree with escape key
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'NvimTree',
      callback = function()
        vim.api.nvim_buf_set_keymap(0, 'n', '<Esc>', ':NvimTreeClose<CR>', { noremap = true, silent = true })
      end,
    })
    vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'explorer', noremap = true, silent = true })
  end,
}
