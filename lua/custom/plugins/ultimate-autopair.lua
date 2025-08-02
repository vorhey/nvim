return {
  'altermo/ultimate-autopair.nvim',
  event = { 'InsertEnter', 'CmdlineEnter' },
  opts = {
    extensions = {
      cond = {
        filter = true,
        cond = function()
          local line = vim.api.nvim_get_current_line()
          local col = vim.api.nvim_win_get_cursor(0)[2]
          local char_before = col > 0 and line:sub(col, col) or ''
          local char_after = col < #line and line:sub(col + 1, col + 1) or ''

          -- Allow flyout when next character is a closing bracket
          if char_after == ')' or char_after == ']' or char_after == '}' then
            return true
          end

          -- Block insertion when adjacent to word characters
          if char_before:match '%w' or char_after:match '%w' then
            return false
          end

          return true
        end,
      },
    },
    internal_pairs = {
      { '[', ']', fly = true, dosuround = true, suround = true, newline = true, space = true },
      { '(', ')', fly = true, dosuround = true, suround = true, newline = true, space = true },
      { '{', '}', fly = true, dosuround = true, suround = true, newline = true, space = true },
    },
  },
}
