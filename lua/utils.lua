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

M.is_supermaven_enabled = function()
  return supermaven_enabled
end

-- Copy line above
M.copy_line_above = function()
  if vim.fn.col '.' > 1 then
    vim.cmd 'normal! ky$jp'
  end
end

M.is_dotnet_installed = function()
  return vim.fn.executable 'dotnet' == 1
end

M.file_info = function()
  local indent_type = vim.bo.expandtab and 'spaces' or 'tabs'
  local indent_size = vim.bo.shiftwidth or vim.bo.tabstop
  local encoding = vim.bo.fileencoding ~= '' and vim.bo.fileencoding or vim.o.encoding
  local format = vim.bo.fileformat
  local filetype = vim.bo.filetype ~= '' and vim.bo.filetype or 'none'

  local message = string.format('Indent: %s(%d) | Encoding: %s | Format: %s | Filetype: %s', indent_type, indent_size, encoding, format, filetype)

  require('mini.notify').make_notify()(message, vim.log.levels.INFO)
end

M.file_diagnostics = function()
  local diagnostics = vim.diagnostic.get()
  local counts = {
    errors = 0,
    warnings = 0,
    info = 0,
    hints = 0,
  }

  for _, diagnostic in ipairs(diagnostics) do
    if diagnostic.severity == vim.diagnostic.severity.ERROR then
      counts.errors = counts.errors + 1
    elseif diagnostic.severity == vim.diagnostic.severity.WARN then
      counts.warnings = counts.warnings + 1
    elseif diagnostic.severity == vim.diagnostic.severity.INFO then
      counts.info = counts.info + 1
    elseif diagnostic.severity == vim.diagnostic.severity.HINT then
      counts.hints = counts.hints + 1
    end
  end

  local message = string.format('󰅙 [%d] Errors |  [%d] Warnings', counts.errors, counts.warnings, counts.info, counts.hints)

  require('mini.notify').make_notify()(message, vim.log.levels.INFO)
end

M.code_action_on_selection = function()
  vim.lsp.buf.code_action {
    range = {
      ['start'] = vim.api.nvim_buf_get_mark(0, '<'),
      ['end'] = vim.api.nvim_buf_get_mark(0, '>'),
    },
  }
end

M.close_all_other_buffers = function()
  local current = vim.api.nvim_get_current_buf()
  local buffers = vim.tbl_filter(function(buf)
    return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
  end, vim.api.nvim_list_bufs())

  for _, buf in ipairs(buffers) do
    if buf ~= current then
      require('mini.bufremove').delete(buf, false)
    end
  end
end

M.close_current_buffer = function()
  local current = vim.api.nvim_get_current_buf()
  if vim.api.nvim_buf_is_valid(current) then
    require('mini.bufremove').delete(current, false)
  end
end

M.ignore_patterns = {
  -- Version Control
  '.git',

  -- Node.js
  'node_modules',
  '.next',
  '.npm',
  '.yarn',

  -- Build outputs
  'dist',
  'target',
  'build',
  'coverage',
  '__snapshots__',

  -- Python
  '**pycache**',
  '.venv',
  '.pytest_cache',
  '.mypy_cache',
  '.ruff_cache',

  -- .NET
  'bin',
  'obj',
  'Debug',
  'Release',
  '.vs',
  'packages',
  'TestResults',

  -- IDE and editors
  '.idea',
  '.vscode',

  -- Package managers
  'vendor',
  '.bundle',
  '.cargo',

  -- Caches and temps
  '.cache',
  'tmp',
  'temp',
  'logs',

  -- Other tools
  '.terraform',
  '.gradle',
  '.DS_Store',
}

M.mason_servers = {
  'gopls',
  'lua_ls',
  'html',
  'cssls',
  'angularls',
  'jsonls',
  'vtsls',
  'dockerls',
  'docker_compose_language_service',
  'emmet_language_server',
  'bashls',
  'groovyls',
  'cucumber_language_server',
  'eslint',
  'intelephense',
  'clangd',
  'basedpyright',
  'jdtls',
}
return M
