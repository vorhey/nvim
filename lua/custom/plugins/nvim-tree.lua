local HEIGHT_RATIO = 0.9
local WIDTH_RATIO = 0.8

return {
  'nvim-tree/nvim-tree.lua',
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
            local window_w = screen_w * WIDTH_RATIO
            local window_h = screen_h * HEIGHT_RATIO
            local window_w_int = math.floor(window_w)
            local window_h_int = math.floor(window_h)
            local center_x = (screen_w - window_w) / 2
            local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
            return {
              border = 'rounded',
              relative = 'editor',
              row = center_y,
              col = center_x,
              width = window_w_int,
              height = window_h_int,
            }
          end,
        },
        width = function()
          return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
        end,
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
    vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'explorer', noremap = true })
  end,
}
