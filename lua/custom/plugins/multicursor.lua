return {
  'jake-stewart/multicursor.nvim',
  branch = '1.0',
  config = function()
    local mc = require 'multicursor-nvim'

    mc.setup()

    -- Add cursors above/below the main cursor.
    vim.keymap.set({ 'n', 'v' }, '<up>', function()
      mc.addCursor 'k'
    end)
    vim.keymap.set({ 'n', 'v' }, '<down>', function()
      mc.addCursor 'j'
    end)

    -- Add a cursor and jump to the next word under cursor.
    vim.keymap.set({ 'n', 'v' }, '<A-m>', function()
      mc.addCursor '*'
    end)

    -- Jump to the next word under cursor but do not add a cursor.
    vim.keymap.set({ 'n', 'v' }, '<c-g>', function()
      mc.skipCursor '*'
    end)

    vim.keymap.set({ 'n', 'x' }, '<leader>mn', function()
      mc.matchAddCursor(1)
      vim.fn['repeat#set'](vim.api.nvim_replace_termcodes('<leader>mn', true, true, true), -1)
    end, { desc = 'add cursor forward' })
    vim.keymap.set({ 'n', 'x' }, '<leader>ms', function()
      mc.matchSkipCursor(1)
    end, { desc = 'skip cursor forward' })
    vim.keymap.set({ 'n', 'x' }, '<leader>mN', function()
      mc.matchAddCursor(-1)
    end, { desc = 'add cursor backward' })
    vim.keymap.set({ 'n', 'x' }, '<leader>mS', function()
      mc.matchSkipCursor(-1)
    end, { desc = 'skip cursor backward' })

    vim.keymap.set('n', '<esc>', function()
      if not mc.cursorsEnabled() then
        mc.enableCursors()
      elseif mc.hasCursors() then
        mc.clearCursors()
        vim.cmd 'nohl'
      else
        vim.cmd 'nohl'
      end
    end)

    -- Customize how cursors look.
    vim.api.nvim_set_hl(0, 'MultiCursorCursor', { link = 'Cursor' })
    vim.api.nvim_set_hl(0, 'MultiCursorVisual', { link = 'Visual' })
    vim.api.nvim_set_hl(0, 'MultiCursorDisabledCursor', { link = 'Visual' })
    vim.api.nvim_set_hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
  end,
}
