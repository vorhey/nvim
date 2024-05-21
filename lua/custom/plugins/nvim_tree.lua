return {
  'nvim-tree/nvim-tree.lua',
  opts = {
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
      adaptive_size = true,
      side = 'left',
      width = 45,
      relativenumber = true,
    },
    git = {
      enable = true,
      ignore = true,
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
            unstaged = '',
            staged = '󰞑',
            unmerged = '',
            renamed = '➜',
            untracked = '󰊠',
            deleted = '',
            ignored = '◌',
          },
          modified = '●',
        },
      },
    },
  },
}
