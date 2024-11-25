local M = {}

-- Expand curly braces c# style
local function remove_braces(line)
  return line:gsub('%s*{%s*}', '')
end

local function create_braces_block(trimmed_line, indent)
  local new_lines = { trimmed_line }
  table.insert(new_lines, indent .. '{')
  table.insert(new_lines, indent .. '    ')
  table.insert(new_lines, indent .. '}')
  return new_lines
end

function M.expand_braces()
  local bufnr = vim.api.nvim_get_current_buf()
  local line_num = vim.fn.getcurpos()[2] - 1
  local line = vim.api.nvim_buf_get_lines(bufnr, line_num, line_num + 1, false)[1]
  local indent = line:match '^%s*'

  if line:find '{%s*}' then
    local trimmed_line = remove_braces(line)
    local new_lines = create_braces_block(trimmed_line, indent)

    vim.api.nvim_buf_set_lines(bufnr, line_num, line_num + 1, false, new_lines)
    vim.api.nvim_win_set_cursor(0, { line_num + 3, #indent + 4 })
    vim.cmd 'startinsert!'
  end
end

function M.toggle_autoformat()
  if vim.g.disable_autoformat then
    vim.g.disable_autoformat = false
    print 'Autoformat enabled'
  else
    vim.g.disable_autoformat = true
    print 'Autoformat disabled'
  end
end

-- Helper to scroll down half a screen
function M.lazy(keys)
  keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
  return function()
    local old = vim.o.lazyredraw
    vim.o.lazyredraw = true
    vim.api.nvim_feedkeys(keys, 'nx', false)
    vim.o.lazyredraw = old
  end
end

-- check wsl
function M.is_wsl()
  local output = vim.fn.systemlist 'uname -r'
  return not not string.find(output[1] or '', 'WSL')
end

--- Get highlight properties for a given highlight name
--- @param name string The highlight group name
--- @param fallback? table The fallback highlight properties
--- @return table properties # the highlight group properties
function M.get_hlgroup(name, fallback)
  if vim.fn.hlexists(name) == 1 then
    local group = vim.api.nvim_get_hl(0, { name = name })

    local hl = {
      fg = group.fg == nil and 'NONE' or M.parse_hex(group.fg),
      bg = group.bg == nil and 'NONE' or M.parse_hex(group.bg),
    }

    return hl
  end
  return fallback or {}
end

--- Remove a buffer by its number without affecting window layout
--- @param buf? number The buffer number to delete
function M.delete_buffer(buf)
  if buf == nil or buf == 0 then
    buf = vim.api.nvim_get_current_buf()
  end

  vim.api.nvim_command('bwipeout ' .. buf)
end

--- Switch to the previous buffer
function M.switch_to_previous_buffer()
  local ok, _ = pcall(function()
    vim.cmd 'buffer #'
  end)
  if not ok then
    vim.notify('No other buffer to switch to!', 3, { title = 'Warning' })
  end
end

--- Get the number of open buffers
--- @return number
function M.get_buffer_count()
  local count = 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.bufname(buf) ~= '' then
      count = count + 1
    end
  end
  return count
end

--- Parse a given integer color to a hex value.
--- @param int_color number
function M.parse_hex(int_color)
  return string.format('#%x', int_color)
end

--- Toggle supermaven
local supermaven_enabled = false
M.toggle_supermaven = function()
  local api = require 'supermaven-nvim.api'
  supermaven_enabled = not supermaven_enabled
  api.toggle()
  if supermaven_enabled then
    api.start()
  else
    api.stop()
  end
  print('Supermaven ' .. (supermaven_enabled and 'enabled' or 'disabled'))
end

-- Copy line above
M.copy_line_above = function()
  if vim.fn.col '.' > 1 then
    vim.cmd 'normal! ky$jp'
  end
end

-- Semantic tokens
M.semantick_tokens = function(client)
  -- NOTE: Super hacky... Don't know if I like that we set a random variable on the client
  -- Seems to work though
  if client.is_hacked then
    return
  end
  client.is_hacked = true

  -- let the runtime know the server can do semanticTokens/full now
  client.server_capabilities = vim.tbl_deep_extend('force', client.server_capabilities, {
    semanticTokensProvider = {
      full = true,
    },
  })

  -- monkey patch the request proxy
  local request_inner = client.request
  client.request = function(method, params, handler, req_bufnr)
    if method ~= vim.lsp.protocol.Methods.textDocument_semanticTokens_full then
      return request_inner(method, params, handler)
    end

    local target_bufnr = vim.uri_to_bufnr(params.textDocument.uri)
    local line_count = vim.api.nvim_buf_line_count(target_bufnr)
    local last_line = vim.api.nvim_buf_get_lines(target_bufnr, line_count - 1, line_count, true)[1]

    return request_inner('textDocument/semanticTokens/range', {
      textDocument = params.textDocument,
      range = {
        ['start'] = {
          line = 0,
          character = 0,
        },
        ['end'] = {
          line = line_count - 1,
          character = string.len(last_line) - 1,
        },
      },
    }, handler, req_bufnr)
  end
end

M.is_dotnet_installed = function()
  return vim.fn.executable 'dotnet' == 1
end

M.pick_file = function(glob_pattern, ignore_patterns)
  return coroutine.create(function(dap_run_co)
    require('telescope.builtin').find_files {
      cwd = vim.fn.getcwd(),
      file_ignore_patterns = ignore_patterns or {},
      find_command = { 'rg', '--files', '--glob', glob_pattern },
      respect_gitignore = false,
      previewer = false,
      attach_mappings = function(_, map)
        map('i', '<CR>', function(prompt_bufnr)
          local selection = require('telescope.actions.state').get_selected_entry()
          require('telescope.actions').close(prompt_bufnr)
          coroutine.resume(dap_run_co, selection.value)
        end)
        return true
      end,
    }
  end)
end

return M
