return {
  'yetone/avante.nvim',
  build = vim.fn.has 'win32' ~= 0 and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false' or 'make',
  event = 'VeryLazy',
  version = false,
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    mode = 'legacy',
    provider = 'gemini',
    selection = {
      hint_display = 'none',
    },
    windows = {
      width = 40,
      sidebar_header = { enabled = false },
      input = { prefix = '' },
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'hrsh7th/nvim-cmp',
    'folke/snacks.nvim',
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = { file_types = { 'markdown', 'Avante' } },
      ft = { 'markdown', 'Avante' },
    },
  },
}
-- Key Binding	Description
-- Sidebar
-- ]p	next prompt
-- [p	previous prompt
-- a A	apply all
-- a	apply cursor
-- r	retry user request
-- e	edit user request
-- <Tab>	switch windows
-- <S-Tab>	reverse switch windows
-- d	remove file
-- @	add file
-- q	close sidebar
-- Leaderaa	show sidebar
-- Leaderat	toggle sidebar visibility
-- Leaderar	refresh sidebar
-- Leaderaf	switch sidebar focus

-- Suggestion
-- Leadera?	select model
-- Leaderan	new ask
-- Leaderae	edit selected blocks
-- LeaderaS	stop current AI request
-- Leaderah	select between chat histories
-- <M-l>	accept suggestion
-- <M-]>	next suggestion
-- <M-[>	previous suggestion
-- <C-]>	dismiss suggestion
-- Leaderad	toggle debug mode
-- Leaderas	toggle suggestion display
-- LeaderaR	toggle repomap

-- Files
-- Leaderac	add current buffer to selected files
-- LeaderaB	add all buffer files to selected files

-- Diff
-- co	choose ours
-- ct	choose theirs
-- ca	choose all theirs
-- cb	choose both
-- cc	choose cursor
-- ]x	move to next conflict
-- [x	move to previous conflict

-- Confirm
-- Ctrlwf	focus confirm window
-- c	confirm code
-- r	confirm response
-- i	confirm input
