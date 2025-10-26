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
    },
  },
  config = function(_, opts)
    require('mason-tool-installer').setup(opts)
  end,
}
