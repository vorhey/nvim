return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'williamboman/mason.nvim',
  },
  config = function()
    local formatters_by_ft = {
      lua = { 'stylua' },
      html = { 'prettier' },
      go = { 'goimports' },
      javascript = { 'prettierd' },
      typescript = { 'prettierd' },
      typescriptreact = { 'prettierd' },
      javascriptreact = { 'prettierd' },
      json = { 'prettierd' },
      scss = { 'prettierd' },
      sh = { 'shfmt' },
      bash = { 'shfmt' },
      zsh = { 'shfmt' },
      groovy = { 'npm-groovy-lint' },
      python = { 'ruff_format' },
      java = { 'spotless' },
      sql = { 'sql_formatter' },
    }

    local conform = require 'conform'

    conform.formatters.spotless = {
      command = './gradlew',
      args = { 'spotlessApply' },
      stdin = false,
      inherit = false,
      cwd = function()
        return vim.fn.finddir('.git/..', vim.fn.expand '%:p:h' .. ';')
      end,
    }

    conform.setup {
      notify_on_error = false,
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        local filetype = vim.bo[bufnr].filetype
        -- Java files with spotless need synchronous formatting
        if filetype == 'java' then
          return {
            async = false,
            timeout_ms = 15000,
            lsp_format = 'fallback',
          }
        end
        -- Return nil for other filetypes to not use format_on_save
        return nil
      end,
      format_after_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat or vim.bo[bufnr].filetype == 'java' then
          return
        end
        return {
          async = true,
          timeout_ms = 15000,
          lsp_format = 'fallback',
        }
      end,
      formatters_by_ft = formatters_by_ft,
    }
  end,
}
