return {
  'altermo/ultimate-autopair.nvim',
  event = { 'InsertEnter', 'CmdlineEnter' },
  branch = 'v0.6',
  opts = {
    internal_pairs = {
      { '[', ']', alpha_after = true, newline = true },
      { '(', ')', alpha_after = true, newline = true },
      { '{', '}', alpha_after = true, newline = true },
      { '"', '"', alpha_after = true },
      { "'", "'", alpha_after = true },
      { '`', '`', alpha_after = true },
    },
  },
}
