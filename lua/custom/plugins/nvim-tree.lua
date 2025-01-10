local HEIGHT_RATIO = 0.8 -- You can change this
local WIDTH_RATIO = 0.8 -- You can change this too

return {
  'nvim-tree/nvim-tree.lua',
  cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
  config = function()
    require('nvim-tree').setup {
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
  end,
}
