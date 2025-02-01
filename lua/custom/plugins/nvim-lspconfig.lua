---@diagnostic disable: missing-fields
return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'b0o/schemastore.nvim',
    { 'nvim-flutter/flutter-tools.nvim', lazy = true, ft = { 'dart' } },
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    { 'seblj/roslyn.nvim', lazy = true, ft = { 'cs' } },
    {
      'folke/lazydev.nvim',
      dependencies = { 'Bilal2453/luvit-meta', lazy = true },
      ft = 'lua',
      opts = { library = { { path = 'luvit-meta/library', words = { 'vim%.uv' } } } },
    },
  },

  config = function()
    local utils = require 'utils'
    -- Disable virtual text
    vim.diagnostic.config { virtual_text = false }

    -- Capabilities
    local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    -- Handlers
    local handlers = {
      ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = 'rounded',
      }),
      ['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
        signs = true,
        severity_sort = true,
        update_in_insert = false,
      }),
    }

    -- Diagnostics signs
    for _, sign in ipairs {
      { name = 'DiagnosticSignError', text = '' },
      { name = 'DiagnosticSignWarn', text = '' },
      { name = 'DiagnosticSignHint', text = '' },
      { name = 'DiagnosticSignInfo', text = '' },
    } do
      vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
    end

    -- Keymaps
    local function setup_lsp_keymaps(bufnr)
      local opts = { buffer = bufnr }

      local function format_buffer()
        vim.lsp.buf.format { async = true }
      end

      local function format_selection()
        vim.lsp.buf.format { range = { vim.fn.line "'<", vim.fn.line "'>" } }
      end

      local function toggle_inlay_hints()
        if vim.lsp.inlay_hint.is_enabled() then
          vim.lsp.inlay_hint.enable(false)
        else
          vim.lsp.inlay_hint.enable()
        end
      end

      vim.keymap.set('n', '<leader>lf', format_buffer, vim.tbl_extend('force', opts, { desc = 'lsp: format buffer' }))
      vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, vim.tbl_extend('force', opts, { desc = 'lsp: diagnostic messages' }))
      vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'lsp: rename' }))
      vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'lsp: code action' }))
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'lsp: hover documentation' }))
      vim.keymap.set('n', 'gR', vim.lsp.buf.references, vim.tbl_extend('force', opts, { desc = 'lsp: native references' }))
      vim.keymap.set('n', '<leader>li', toggle_inlay_hints, vim.tbl_extend('force', opts, { desc = 'lsp: file information' }))
      vim.keymap.set('v', '<leader>la', utils.code_action_on_selection, vim.tbl_extend('force', opts, { desc = 'lsp: range code action' }))
      vim.keymap.set('v', '<leader>lf', format_selection, vim.tbl_extend('force', opts, { desc = 'lsp: format selection' }))
      vim.keymap.set('i', '<c-k>', vim.lsp.buf.signature_help, vim.tbl_extend('force', opts, { desc = 'lsp: signature help' }))
    end

    -- Autocommands
    local function setup_document_highlight(client, bufnr)
      if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = bufnr,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = bufnr,
          callback = vim.lsp.buf.clear_references,
        })
      end
    end

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach-group', { clear = true }),
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client then
          return
        end
        if client.name == 'jdtls' then
          client.server_capabilities.semanticTokensProvider = nil
        end
        setup_lsp_keymaps(event.buf)
        setup_document_highlight(client, event.buf)
      end,
    })

    -- Server Configurations
    local servers = {
      cucumber_language_server = {
        handlers = vim.tbl_extend('force', handlers, {
          ['textDocument/publishDiagnostics'] = function(_, result, ctx, config)
            if result.diagnostics then
              local IGNORED_DIAGNOSTIC_CODES = {
                ['cucumber.undefined-step'] = true,
              }
              result.diagnostics = vim.tbl_filter(function(diagnostic)
                return not IGNORED_DIAGNOSTIC_CODES[diagnostic.code]
              end, result.diagnostics)
            end
            vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
          end,
        }),
      },
      lua_ls = {
        settings = {
          Lua = {
            hint = {
              enable = true,
              arrayIndex = 'Disable',
            },
            runtime = {
              version = 'LuaJIT',
              path = vim.split(package.path, ';'),
            },
            diagnostics = {
              globals = { 'vim', 'use' },
              disable = { 'missing-parameter' },
            },
            workspace = {
              library = {},
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
            completion = {
              callSnippet = 'Replace',
            },
          },
        },
      },
      jsonls = {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      },
      gopls = {
        cmd = { 'gopls', 'serve' },
        settings = {
          gopls = {
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              constantValues = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            gofumpt = true,
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            analyses = {
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
            semanticTokens = true,
          },
        },
      },
      vtsls = {
        handlers = vim.tbl_extend('force', handlers, {
          ['textDocument/publishDiagnostics'] = function(_, result, ctx, config)
            if result.diagnostics then
              local IGNORED_DIAGNOSTIC_CODES = {
                [80001] = true,
                [80006] = true,
              }
              result.diagnostics = vim.tbl_filter(function(diagnostic)
                return not IGNORED_DIAGNOSTIC_CODES[diagnostic.code]
              end, result.diagnostics)
            end
            handlers['textDocument/publishDiagnostics'](_, result, ctx, config)
          end,
          ['textDocument/signatureHelp'] = function(err, result, ctx, config)
            if err then
              -- Silently ignore signature help errors
              return
            end
            vim.lsp.handlers['textDocument/signatureHelp'](err, result, ctx, config)
          end,
        }),
        settings = {
          vtsls = {
            experimental = {
              maxInlayHintLength = 20,
              completion = {
                enableServerSideFuzzyMatch = true,
                entriesLimit = 100,
              },
            },
            enableMoveToFileCodeAction = true,
          },
          javascript = {
            inlayHints = {
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = false },
              functionLikeReturnTypes = { enabled = false },
            },
            suggest = {
              enabled = true,
              completeFunctionCalls = true,
              includeCompletionsForImportStatements = true,
              includeAutomaticOptionalChainCompletions = true,
              classMemberSnippets = { enabled = true },
            },
            suggestionActions = { enabled = true },
          },
          typescript = {
            inlayHints = {
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = false },
              functionLikeReturnTypes = { enabled = false },
            },
          },
        },
      },
    }

    -- Mason setup with lazy loading
    require('mason').setup {}
    require('mason-lspconfig').setup {
      ensure_installed = utils.mason_servers,
      handlers = {
        function(server_name)
          local server_config = servers[server_name] or {}
          server_config.capabilities = capabilities
          server_config.handlers = vim.tbl_extend('force', handlers, server_config.handlers or {})
          require('lspconfig')[server_name].setup(server_config)
        end,
      },
    }

    -- JAVA
    local java_home = os.getenv 'JAVA_DEV_HOME' or os.getenv 'JAVA_HOME' or 'java'
    vim.fn.setenv('JAVA_HOME', java_home)
    local mason_registry = require 'mason-registry'

    if mason_registry.is_installed 'jdtls' then
      require('lspconfig').jdtls.setup {
        handlers = handlers,
        capabilities = capabilities,
        cmd = { vim.fn.exepath 'jdtls', '--jvm-arg=-javaagent:' .. mason_registry.get_package('jdtls'):get_install_path() .. '/lombok.jar' },
      }
    end

    -- C#
    require('roslyn').setup {
      config = {
        capabilities = capabilities,
        handlers = handlers,
        on_attach = function(client, bufnr)
          vim.bo[bufnr].tabstop = 4
          vim.bo[bufnr].shiftwidth = 4
          vim.bo[bufnr].expandtab = true
          vim.bo[bufnr].softtabstop = 4
          client.handlers['textDocument/diagnostic'] = vim.lsp.with(vim.lsp.diagnostic.on_diagnostic, {
            virtual_text = { severity = vim.diagnostic.severity.ERROR },
          })
        end,
        filewatching = true,
      },
    }

    -- Flutter
    require('flutter-tools').setup {
      lsp = {
        capabilities = capabilities,
        handlers = handlers,
        settings = {
          enableSnippets = true,
          enableSemantic = true,
          analysisExcludedFolders = {
            vim.fn.expand '$HOME/.pub-cache',
            vim.fn.expand '$HOME/fvm',
          },
          completionBudgetMilliseconds = 1000,
          diagnosticsBudgetMilliseconds = 1000,
          navigationBudgetMilliseconds = 1000,
        },
      },
    }
  end,
}
