return {
  'altermo/ultimate-autopair.nvim',
  event = { 'InsertEnter', 'CmdlineEnter' },
  opts = {
    internal_pairs = {
      { '[', ']', fly = true, dosuround = true, suround = true, newline = true, space = true },
      { '(', ')', fly = true, dosuround = true, suround = true, newline = true, space = true },
      { '{', '}', fly = true, dosuround = true, suround = true, newline = true, space = true },
    },
  },
}
