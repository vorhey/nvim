return {
  'nvim-mini/mini.basics',
  config = function()
    require('mini.basics').setup {
      mappings = {
        windows = true,
        option_toggle_prefix = '',
      },
      silent = true,
    }
  end,
}
-- ==================================================
-- Keybindings set by `mini.basics` (default configuration)
-- ==================================================

-- Basic Mappings (enabled by `mappings.basic = true`)
-- --------------------------------------------------
-- | Keys   | Modes       | Description                                      |
-- |--------|-------------|--------------------------------------------------|
-- | j      | Normal, Visual | Move down by visible lines (no [count])       |
-- | k      | Normal, Visual | Move up by visible lines (no [count])         |
-- | go     | Normal         | Add [count] empty lines after cursor          |
-- | gO     | Normal         | Add [count] empty lines before cursor         |
-- | gy     | Normal, Visual | Copy to system clipboard                      |
-- | gp     | Normal, Visual | Paste from system clipboard                   |
-- | gV     | Normal         | Visually select latest changed/yanked text    |
-- | g/     | Visual         | Search inside current visual selection        |
-- | *      | Visual         | Search forward for current visual selection   |
-- | #      | Visual         | Search backward for current visual selection  |
-- | <C-s>  | Normal, Visual, Insert | Save and go to Normal mode            |
-- --------------------------------------------------

-- Option Toggle Mappings (enabled by `mappings.option_toggle_prefix = '\'`)
-- --------------------------------------------------
-- | Keys   | Modes       | Description                                      |
-- |--------|-------------|--------------------------------------------------|
-- | \b     | Normal      | Toggle 'background' (light/dark)                 |
-- | \c     | Normal      | Toggle 'cursorline'                              |
-- | \C     | Normal      | Toggle 'cursorcolumn'                            |
-- | \d     | Normal      | Toggle diagnostics (vim.diagnostic)              |
-- | \h     | Normal      | Toggle 'hlsearch' (highlight search)             |
-- | \i     | Normal      | Toggle 'ignorecase'                              |
-- | \l     | Normal      | Toggle 'list' (show invisible characters)        |
-- | \n     | Normal      | Toggle 'number'                                  |
-- | \r     | Normal      | Toggle 'relativenumber'                          |
-- | \s     | Normal      | Toggle 'spell'                                   |
-- | \w     | Normal      | Toggle 'wrap'                                    |
-- --------------------------------------------------

-- Window Navigation Mappings (enabled by `mappings.windows = true`)
-- --------------------------------------------------
-- | Keys       | Modes       | Description                                |
-- |------------|-------------|--------------------------------------------|
-- | <C-h>      | Normal      | Move focus to the left window              |
-- | <C-j>      | Normal      | Move focus to the lower window             |
-- | <C-k>      | Normal      | Move focus to the upper window             |
-- | <C-l>      | Normal      | Move focus to the right window             |
-- | <C-left>   | Normal      | Decrease window width                      |
-- | <C-down>   | Normal      | Decrease window height                     |
-- | <C-up>     | Normal      | Increase window height                     |
-- | <C-right>  | Normal      | Increase window width                      |
-- --------------------------------------------------

-- Move with Alt Mappings (enabled by `mappings.move_with_alt = true`)
-- --------------------------------------------------
-- | Keys       | Modes       | Description                                |
-- |------------|-------------|--------------------------------------------|
-- | <M-h>      | Insert, Terminal, Command | Move cursor left             |
-- | <M-j>      | Insert, Terminal          | Move cursor down             |
-- | <M-k>      | Insert, Terminal          | Move cursor up               |
-- | <M-l>      | Insert, Terminal, Command | Move cursor right            |
-- --------------------------------------------------

-- ==================================================
-- Notes:
-- - These keybindings are only created if they don't already exist.
-- - You can disable any of these mappings by setting the corresponding
--   `mappings` option to `false` in the `mini.basics` setup.
-- ==================================================
