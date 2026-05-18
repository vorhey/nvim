return {
  'kevinhwang91/nvim-hlslens',
  event = 'BufRead',
  opts = {},
  config = function()
    local icon = '' -- inline icon shown in the lens virtual text

    require('hlslens').setup {
      calm_down = true,
      nearest_only = true,
      override_lens = function(render, posList, nearest, idx, relIdx)
        local sfw = vim.v.searchforward == 1
        local indicator
        local absRelIdx = math.abs(relIdx)
        if absRelIdx > 1 then
          indicator = ('%d%s'):format(absRelIdx, sfw ~= (relIdx > 1) and 'N' or 'n')
        elseif absRelIdx == 1 then
          indicator = sfw ~= (relIdx == 1) and 'N' or 'n'
        else
          indicator = ''
        end

        local lnum, col = unpack(posList[idx])
        local hl = nearest and 'HlSearchLensNear' or 'HlSearchLens'
        local text
        if nearest then
          local cnt = #posList
          if indicator ~= '' then
            text = ('[%s %d/%d]'):format(indicator, idx, cnt)
          else
            text = ('[%d/%d]'):format(idx, cnt)
          end
        else
          text = ('[%s %d]'):format(indicator, idx)
        end

        local chunks = {
          { ' ', 'Ignore' },
          { icon .. ' ', hl },
          { text, hl },
        }

        render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
      end,
    }
    local kopts = { noremap = true, silent = true }
    vim.api.nvim_set_keymap('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>zz]], kopts)
    vim.api.nvim_set_keymap('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>zz]], kopts)
    vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>zz]], kopts)
    vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>zz]], kopts)
    vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>zz]], kopts)
    vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>zz]], kopts)
  end,
}
