local M = {}

-- Winbar icon (used globally)
_G.get_file_icon = function()
  local extension = vim.fn.expand '%:e'
  if extension == '' then
    return ''
  end
  local icon, _ = require('nvim-web-devicons').get_icon_by_filetype(extension, { default = true })
  return icon .. ' '
end

-- is_wsl (used externally)
vim.g.is_wsl = (function()
  local output = vim.fn.systemlist 'uname -r'
  return output[1] and string.find(output[1], 'WSL') ~= nil
end)()

-- pick_file (used externally)
M.pick_file = function(pattern, ignore_patterns)
  return coroutine.create(function(dap_run_co)
    Snacks.picker.files {
      layout = {
        layout = {
          width = 0.8,
        },
      },
      cwd = vim.fn.getcwd(),
      ft = pattern,
      exclude = ignore_patterns,
      confirm = function(picker, item)
        picker:close()
        coroutine.resume(dap_run_co, item and item.file)
      end,
    }
  end)
end

-- get_relative_filename (used externally)
function M.get_relative_filename()
  local root_patterns = { '.git' }
  local root_path = vim.fs.dirname(vim.fs.find(root_patterns, { upward = true })[1])
  if root_path then
    local full_path = vim.fn.expand '%:p'
    root_path = root_path:gsub('/$', '') .. '/'
    local rel_path = full_path:gsub('^' .. vim.pesc(root_path), '')
    return rel_path
  else
    return '%f'
  end
end

-- ignore_patterns (used externally)
M.ignore_patterns = {
  '.git',
  'node_modules',
  '.next',
  '.npm',
  '.yarn',
  'dist',
  'target',
  'build',
  'coverage',
  '__snapshots__',
  '**pycache**',
  '.venv',
  '.pytest_cache',
  '.mypy_cache',
  '.ruff_cache',
  'bin',
  'obj',
  'Debug',
  'Release',
  '.vs',
  'packages',
  'TestResults',
  '.idea',
  '.vscode',
  'vendor',
  '.bundle',
  '.cargo',
  '.cache',
  'tmp',
  'temp',
  'logs',
  '.terraform',
  '.gradle',
  '.DS_Store',
}

return M
