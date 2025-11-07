return {
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  lazy = true,
  dependencies = {
    'williamboman/mason.nvim',
  },
  opts = {
    run_on_start = false,
    ensure_installed = {
      'stylua',
      'goimports',
      'prettier',
      'prettierd',
      'shfmt',
      'shellcheck',
      'npm-groovy-lint',
      'ruff',
      'sql-formatter',
      'delve',
      'netcoredbg',
      'js-debug-adapter',
      'codelldb',
      'clang-format',
      'debugpy',
    },
  },
  config = function(_, opts)
    -- Check if dotnet is available and add csharpier if it is
    local function is_dotnet_available()
      local handle = io.popen 'command -v dotnet >/dev/null 2>&1 && echo "available"'
      if handle then
        local result = handle:read '*a'
        handle:close()
        return result:match 'available' ~= nil
      end
      return false
    end

    if is_dotnet_available() then
      table.insert(opts.ensure_installed, 'csharpier')
    end

    require('mason-tool-installer').setup(opts)
  end,
}
