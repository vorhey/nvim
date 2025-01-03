return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'b0o/schemastore.nvim',
    'nvim-flutter/flutter-tools.nvim',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    {
      'j-hui/fidget.nvim',
      opts = {
        progress = {
          display = {
            render_limit = 1,
          },
        },
        notification = {
          history_size = 1,
          configs = {
            default = {
              max_messages = 1,
              history = false,
            },
          },
          window = { winblend = 0 },
        },
      },
    },
    { 'seblj/roslyn.nvim', ft = { 'cs', 'axaml.cs' } },
    {
      'folke/lazydev.nvim',
      dependencies = { 'Bilal2453/luvit-meta', lazy = true },
      ft = 'lua',
      opts = { library = { { path = 'luvit-meta/library', words = { 'vim%.uv' } } } },
    },
  },

  config = function()
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
      { name = 'DiagnosticSignError', text = '' }, -- Replace '!' with your error icon
      { name = 'DiagnosticSignWarn', text = '' }, -- Replace '⚠️' with your warning icon
      { name = 'DiagnosticSignHint', text = '' }, -- Replace '' with your hint icon
      { name = 'DiagnosticSignInfo', text = '' }, -- Replace 'ℹ️' with your info icon
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

    -- Mason
    ---@diagnostic disable-next-line: missing-fields
    require('mason').setup {}
    ---@diagnostic disable-next-line: missing-fields
    require('mason-lspconfig').setup {
      ---@diagnostic disable-next-line: missing-fields
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
    }

    local lspconfig = require 'lspconfig'
    local configs = require 'lspconfig.configs'

    if not configs.avalonia then
      configs.avalonia = {
        default_config = {
          cmd = { 'dotnet', vim.fn.expand '~/.local/share/avalonia-ls/extension/avaloniaServer/AvaloniaLanguageServer.dll' },
          filetypes = { 'axaml', 'xaml' },
          root_dir = vim.fn.getcwd(),
          settings = {},
        },
      }
    end

    -- lua
    lspconfig.lua_ls.setup {
      capabilities = capabilities,
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
            library = vim.api.nvim_get_runtime_file('', true),
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
    }

    -- jsonls
    lspconfig.jsonls.setup {
      capabilities = capabilities,
      handlers = handlers,
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
    }

    -- golsp
    lspconfig.gopls.setup {
      capabilities = capabilities,
      handlers = handlers,
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
    }

    -- typescript
    local IGNORED_DIAGNOSTIC_CODES = {
      [80001] = true, -- File is a commonjs module
      [80006] = true, -- This can be converted to an ES module
    }
    lspconfig.vtsls.setup {
      capabilities = capabilities,
      handlers = vim.tbl_extend('force', handlers, {
        ['textDocument/publishDiagnostics'] = function(_, result, ctx, config)
          if result.diagnostics then
            result.diagnostics = vim.tbl_filter(function(diagnostic)
              return not IGNORED_DIAGNOSTIC_CODES[diagnostic.code]
            end, result.diagnostics)
          end
          handlers['textDocument/publishDiagnostics'](_, result, ctx, config)
        end,
        ['textDocument/signatureHelp'] = function(err, result, ctx, config)
          if err then
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
    }

    -- docker
    lspconfig.dockerls.setup {
      capabilities = capabilities,
      handlers = handlers,
    }

    local function set_filetype(pattern, filetype)
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        pattern = pattern,
        command = 'set filetype=' .. filetype,
      })
    end

    set_filetype({ 'docker-compose.yml' }, 'yaml.docker-compose')

    lspconfig.docker_compose_language_service.setup {
      capabilities = capabilities,
      handlers = handlers,
    }

    -- css
    lspconfig.cssls.setup {
      capabilities = capabilities,
      handlers = handlers,
      settings = {
        css = {
          lint = {
            unknownAtRules = 'ignore',
          },
        },
      },
    }

    -- csharp
    require('roslyn').setup {
      ---@diagnostic disable-next-line: missing-fields
      config = {
        capabilities = capabilities,
        handlers = handlers,
        on_attach = function(client, bufnr)
          vim.lsp.set_log_level 'DEBUG'
          vim.bo[bufnr].tabstop = 4
          vim.bo[bufnr].shiftwidth = 4
          vim.bo[bufnr].expandtab = true
          vim.bo[bufnr].softtabstop = 4
          client.handlers['textDocument/diagnostic'] = vim.lsp.with(vim.lsp.diagnostic.on_diagnostic, {
            virtual_text = { severity = vim.diagnostic.severity.ERROR },
          })
          vim.api.nvim_create_autocmd('BufEnter', {
            buffer = bufnr,
            callback = function()
              vim.lsp.codelens.refresh { bufnr = 0 }
              -- workaround for diagnostics not being triggered
              client.request('textDocument/diagnostic', {
                textDocument = vim.lsp.util.make_text_document_params(),
              }, nil, bufnr)
            end,
          })
        end,
        filewatching = true,
      },
    }

    -- emmet-ls
    lspconfig.emmet_language_server.setup { capabilities = capabilities }

    -- bashls
    lspconfig.bashls.setup {
      capabilities = capabilities,
      handlers = handlers,
      filetypes = { 'sh', 'bash', 'zsh' },
    }

    lspconfig.avalonia.setup {
      capabilities = capabilities,
      handlers = handlers,
      filetypes = { 'axaml', 'xaml' },
    }

    -- dart
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

    -- groovy
    lspconfig.groovyls.setup {
      capabilities = capabilities,
      handlers = handlers,
    }

    -- cucumber
    lspconfig.cucumber_language_server.setup {
      capabilities = capabilities,
      handlers = handlers,
    }

    -- eslint
    lspconfig.eslint.setup {
      handlers = handlers,
      capabilities = capabilities,
    }

    -- php
    lspconfig.intelephense.setup {
      handlers = handlers,
      capabilities = capabilities,
    }

    --clangd
    lspconfig.clangd.setup {
      handlers = handlers,
      capabilities = capabilities,
    }

    -- python
    lspconfig.basedpyright.setup {
      handlers = handlers,
      capabilities = capabilities,
      settings = {
        basedpyright = {
          analysis = {
            diagnosticSeverityOverrides = {
              reportUnknownParameterType = 'none',
              reportMissingParameterType = 'none',
              reportUnknownArgumentType = 'none',
              reportUnusedCallResult = 'none',
              reportUnknownMemberType = 'none',
              reportImplicitStringConcatenation = 'none',
              reportUnknownVariableType = 'none',
              reportAny = 'none',
              reportArgumentType = 'none',
              reportMissingTypeStubs = 'none',
              reportOptionalSubscript = 'none',
            },
          },
        },
      },
    }

    -- jdtls
    -- Path configurations
    local home = os.getenv 'HOME'
    local mason_path = home .. '/.local/share/nvim/mason'
    local jdtls_path = mason_path .. '/packages/jdtls'
    -- Workspace configuration
    local function get_workspace_dir()
      local workspace_path = home .. '/.local/share/nvim/jdtls-workspace/'
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
      return workspace_path .. project_name
    end
    -- JVM arguments
    local function get_jvm_args()
      return {
        '-noverify',
        '-Xmx4G',
        '-XX:+UseG1GC',
        '-XX:+UseStringDeduplication',
        '--add-modules=ALL-SYSTEM',
        '--add-opens',
        'java.base/java.util=ALL-UNNAMED',
        '--add-opens',
        'java.base/java.lang=ALL-UNNAMED',
      }
    end
    -- JDTLS specific arguments
    local function get_jdtls_args()
      return {
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
      }
    end
    -- Java settings
    local java_settings = {
      java = {
        maven = {
          downloadSources = true,
        },
        referencesCodeLens = {
          enabled = true,
        },
        references = {
          includeDecompiledSources = true,
        },
        inlayHints = {
          parameterNames = {
            enabled = 'all', -- literals, all, none
          },
        },
      },
    }
    lspconfig.jdtls.setup {
      cmd = {
        'java',
        unpack(get_jdtls_args()),
        unpack(get_jvm_args()),
        '-javaagent:' .. jdtls_path .. '/lombok.jar',
        '-jar',
        vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
        '-configuration',
        jdtls_path .. '/config_linux',
        '-data',
        get_workspace_dir(),
      },
      settings = java_settings,
    }
  end,
}
