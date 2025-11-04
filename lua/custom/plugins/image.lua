return {
  '3rd/image.nvim',
  enabled = vim.g.is_wsl,
  build = false,
  config = function()
    require('image').setup {
      backend = 'sixel',
      processor = 'magick_cli',
      integrations = {
        markdown = {
          only_render_image_at_cursor = true,
          only_render_image_at_cursor_mode = 'inline',
        },
      },
      hijack_file_patterns = {
        '*.png',
        '*.jpg',
        '*.jpeg',
        '*.gif',
        '*.webp',
        '*.avif',
        '*.svg',
        '*.ico',
      },
    }
  end,
}
