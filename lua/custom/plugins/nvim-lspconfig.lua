---@diagnostic disable: missing-fields
return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'b0o/schemastore.nvim',
    {
      'nvim-flutter/flutter-tools.nvim',
      lazy = true,
      ft = { 'dart' },
    },
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    {
      'seblj/roslyn.nvim',
      lazy = true,
      ft = { 'cs' },
    },
    {
      'folke/lazydev.nvim',
      dependencies = { 'Bilal2453/luvit-meta', lazy = true },
      ft = 'lua',
      opts = { library = { { path = 'luvit-meta/library', words = { 'vim%.uv' } } } },
    },
    {
      'mfussenegger/nvim-jdtls',
      lazy = true,
      ft = { 'java' },
    },
  },

  config = function()
    vim.diagnostic.config { virtual_text = false }

    -- Capabilities
    local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    -- Handlers
    local handlers = {
      ['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
        signs = true,
        severity_sort = true,
        update_in_insert = false,
      }),
    }

    -- Diagnostics signs
    local signs = {
      { name = 'DiagnosticSignError', text = '' },
      { name = 'DiagnosticSignWarn', text = '' },
      { name = 'DiagnosticSignHint', text = '' },
      { name = 'DiagnosticSignInfo', text = '' },
    }

    for _, sign in ipairs(signs) do
      vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
    end

    -- Keymaps
    local function setup_lsp_keymaps(bufnr)
      local opts = { buffer = bufnr }
      local function format_buffer()
        vim.lsp.buf.format { async = true }
      end

      vim.keymap.set('n', '<leader>lf', format_buffer, vim.tbl_extend('force', opts, { desc = 'LSP: Format buffer' }))
      vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, vim.tbl_extend('force', opts, { desc = 'LSP: Diagnostic messages' }))
      vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'LSP: Rename' }))
      vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'LSP: Code Action' }))
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'LSP: Hover Documentation' }))
      vim.keymap.set('n', 'gR', vim.lsp.buf.references, vim.tbl_extend('force', opts, { desc = 'LSP: Native References' }))
      vim.keymap.set('v', '<leader>la', function()
        vim.lsp.buf.code_action {
          range = {
            ['start'] = vim.api.nvim_buf_get_mark(0, '<'),
            ['end'] = vim.api.nvim_buf_get_mark(0, '>'),
          },
        }
      end, vim.tbl_extend('force', opts, { desc = 'LSP: Range Code Action' }))
    end

    -- Document highlight
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

    -- LSP attach
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach-group', { clear = true }),
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client then
          return
        end

        setup_lsp_keymaps(event.buf)
        setup_document_highlight(client, event.buf)
      end,
    })

    -- JDTLS
    local home = os.getenv 'HOME'
    local mason_path = home .. '/.local/share/nvim/mason'

    local function get_workspace_dir()
      local workspace_path = home .. '/.local/share/nvim/jdtls-workspace/'
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
      return workspace_path .. project_name
    end

    local java_home = os.getenv 'JAVA_DEV_HOME' or os.getenv 'JAVA_HOME' or 'java'
    -- Set JAVA_HOME in the process environment so jdtls script can find it
    vim.fn.setenv('JAVA_HOME', java_home)

    local function setup_jdtls()
      local jdtls = require 'jdtls'
      local jdtls_config = {
        cmd = {
          mason_path .. '/bin/jdtls',
          '--jvm-arg=-Xmx1g',
          '-data',
          get_workspace_dir(),
        },

        root_dir = require('jdtls.setup').find_root { 'gradlew', '.git', 'mvnw' },

        settings = {
          java = {
            signatureHelp = { enabled = true },
            contentProvider = { preferred = 'fernflower' },
            semanticHighlighting = {
              enabled = true,
            },
            completion = {
              favoriteStaticMembers = {
                'org.junit.Assert.*',
                'org.junit.Assume.*',
                'org.junit.jupiter.api.Assertions.*',
                'org.junit.jupiter.api.Assumptions.*',
              },
            },
          },
        },

        capabilities = vim.tbl_extend('keep', capabilities, {
          textDocument = {
            semanticTokens = {
              dynamicRegistration = false,
              tokenTypes = {
                'namespace',
                'type',
                'class',
                'enum',
                'interface',
                'struct',
                'typeParameter',
                'parameter',
                'variable',
                'property',
                'enumMember',
                'event',
                'function',
                'method',
                'macro',
                'keyword',
                'modifier',
                'comment',
                'string',
                'number',
                'regexp',
                'operator',
              },
              tokenModifiers = {
                'declaration',
                'definition',
                'readonly',
                'static',
                'deprecated',
                'abstract',
                'async',
                'modification',
                'documentation',
                'defaultLibrary',
              },
              formats = { 'relative' },
            },
          },
        }),
        handlers = handlers,

        on_attach = function(client, bufnr)
          -- Regular LSP keymaps
          client.server_capabilities.semanticTokensProvider = {
            full = true,
            legend = {
              tokenTypes = {},
              tokenModifiers = {},
            },
            range = true,
          }
          setup_lsp_keymaps(bufnr)
          setup_document_highlight(client, bufnr)
        end,
      }

      -- Start JDTLS
      jdtls.start_or_attach(jdtls_config)
    end

    -- Server Configurations
    local servers = {
      lua_ls = {
        settings = {
          Lua = {
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
            gofumpt = true,
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
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
              completion = {
                enableServerSideFuzzyMatch = true,
                entriesLimit = 100,
              },
            },
            enableMoveToFileCodeAction = true,
          },
          javascript = {
            suggest = {
              enabled = true,
              completeFunctionCalls = true,
              includeCompletionsForImportStatements = true,
              includeAutomaticOptionalChainCompletions = true,
              classMemberSnippets = { enabled = true },
            },
            suggestionActions = { enabled = true },
            preferences = {
              importModuleSpecifierEnding = 'js',
            },
          },
        },
      },
    }

    -- Mason setup with lazy loading
    require('mason').setup {}
    require('mason-lspconfig').setup {
      ensure_installed = {
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
      },
      handlers = {
        function(server_name)
          local server_config = servers[server_name] or {}
          server_config.capabilities = capabilities
          server_config.handlers = vim.tbl_deep_extend('force', handlers, server_config.handlers or {})
          require('lspconfig')[server_name].setup(server_config)
        end,
      },
    }

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

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'java',
      callback = setup_jdtls,
      group = vim.api.nvim_create_augroup('JavaLSP', { clear = true }),
    })
  end,
}
