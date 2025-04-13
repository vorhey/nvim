---@diagnostic disable: missing-fields
return {
  'williamboman/mason.nvim',
  event = 'VeryLazy',
  dependencies = {
    { 'b0o/schemastore.nvim', lazy = true },
    { 'williamboman/mason.nvim', lazy = true },
    { 'williamboman/mason-lspconfig.nvim', lazy = true },
    { 'seblj/roslyn.nvim', lazy = true, ft = { 'cs' } },
    { 'luckasRanarison/tailwind-tools.nvim', lazy = true, ft = { 'js', 'jsx', 'ts', 'tsx' } },
    {
      'folke/lazydev.nvim',
      lazy = true,
      dependencies = { 'Bilal2453/luvit-meta', lazy = true },
      ft = 'lua',
      opts = { library = { { path = 'luvit-meta/library', words = { 'vim%.uv' } } } },
    },
    {
      'Chaitanyabsprip/fastaction.nvim',
      ---@type FastActionConfig
      opts = {},
    },
  },
  lazy = true,
  config = function()
    -- Mason configuration
    require('mason').setup { ui = { delay = 1000 } }

    -- Mason LSP configuration
    require('mason-lspconfig').setup {
      ensure_installed = {
        'lua_ls',
        'vtsls',
        'cssls',
        'jsonls',
        'gopls',
        'tailwindcss',
        'eslint',
      },
    }

    vim.diagnostic.config {
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅗',
          [vim.diagnostic.severity.WARN] = '󰩳',
          [vim.diagnostic.severity.HINT] = '',
          [vim.diagnostic.severity.INFO] = '',
        },
      },
      underline = {
        severity = {
          [vim.diagnostic.severity.INFO] = { underline = false },
        },
      },
    }

    -- Use default capabilities instead of custom module
    local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

    -- Set default LSP configuration
    vim.lsp.config('*', {
      capabilities = capabilities,
      root_markers = { '.git' },
    })

    -- Configure Lua language server
    vim.lsp.config('lua_ls', {
      cmd = { 'lua-language-server' },
      filetypes = { 'lua' },
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
    })

    -- Configure vtsls
    vim.lsp.config('vtsls', {
      cmd = { 'vtsls', '--stdio' },
      filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
      handlers = {
        ['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
          if result.diagnostics then
            local IGNORED_DIAGNOSTIC_CODES = {
              [80001] = true, -- Import can be automatically included
              [80006] = true, -- This may be converted to an async function
              [7044] = true, -- Parameter has implicitly 'any' type
            }
            result.diagnostics = vim.tbl_filter(function(diagnostic)
              return not IGNORED_DIAGNOSTIC_CODES[diagnostic.code]
            end, result.diagnostics)
          end
          return vim.lsp.handlers['textDocument/publishDiagnostics'](err, result, ctx, config)
        end,
      },
      settings = {
        vtsls = {
          enableMoveToFileCodeAction = true,
          experimental = {
            maxInlayHintLength = 20,
            completion = {
              enableServerSideFuzzyMatch = true,
              entriesLimit = 100,
            },
          },
        },
        javascript = {
          updateImportsOnFileMove = { enabled = 'always' },
          inlayHints = {
            parameterTypes = { enabled = true },
            variableTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            enumMemberValues = { enabled = true },
            parameterNames = { enabled = 'literals' },
          },
          suggest = {
            enabled = true,
            completeFunctionCalls = true,
            includeCompletionsForImportStatements = true,
            includeAutomaticOptionalChainCompletions = true,
            classMemberSnippets = { enabled = true },
          },
          suggestionActions = { enabled = true },
          preferences = {
            importModuleSpecifier = 'shortest',
          },
        },
        typescript = {
          updateImportsOnFileMove = { enabled = 'always' },
          inlayHints = {
            parameterTypes = { enabled = true },
            variableTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = false },
            functionLikeReturnTypes = { enabled = false },
          },
          referencesCodeLens = {
            enabled = true,
            showOnAllFunctions = false,
          },
          implementationsCodeLens = {
            enabled = true,
          },
        },
      },
    })

    -- Configure ESLint language server
    vim.lsp.config('eslint', {
      cmd = { 'vscode-eslint-language-server', '--stdio' },
      filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx', 'vue', 'svelte', 'astro' },
      root_markers = { '.git', '.eslintrc.js', '.eslintrc.cjs', '.eslintrc.json', 'package.json' }, -- Added package.json
      settings = {
        codeAction = {
          disableRuleComment = {
            enable = true,
            location = 'separateLine',
          },
          showDocumentation = {
            enable = true,
          },
        },
        codeActionOnSave = {
          enable = false,
          mode = 'all',
        },
        experimental = {
          useFlatConfig = false,
        },
        format = true,
        nodePath = '',
        onIgnoredFiles = 'off',
        problems = {
          shortenToSingleLine = false,
        },
        quiet = false,
        rulesCustomizations = {},
        run = 'onType',
        useESLintClass = false,
        validate = 'on',
        workingDirectory = {
          mode = 'location',
        },
      },
    })
    -- Configure JSON language server
    vim.lsp.config('jsonls', {
      cmd = { 'vscode-json-language-server', '--stdio' },
      filetypes = { 'json' },
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
    })

    -- Configure Go language server
    vim.lsp.config('gopls', {
      cmd = { 'gopls' },
      root_markers = { '.git', 'go.mod', 'go.work', vim.uv.cwd() },
      filetypes = { 'go', 'gotempl', 'gowork', 'gomod' },
      settings = {
        gopls = {
          semanticTokens = true,
          completeUnimported = true,
          usePlaceholders = true,
          analyses = {
            unusedparams = true,
          },
          ['ui.inlayhint.hints'] = {
            compositeLiteralFields = true,
            constantValues = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },
      },
    })

    -- Configure CSS language server
    vim.lsp.config('cssls', {
      cmd = { 'vscode-css-language-server', '--stdio' },
      filetypes = { 'css', 'scss', 'less' },
      settings = {
        css = { validate = true, lint = { unknownAtRules = 'ignore' } },
        scss = { validate = true, lint = { unknownAtRules = 'ignore' } },
        less = { validate = true, lint = { unknownAtRules = 'ignore' } },
      },
    })

    -- Configure Tailwind CSS server
    vim.lsp.config('tailwindcss', {
      cmd = { 'tailwindcss-language-server', '--stdio' },
      filetypes = {
        'aspnetcorerazor',
        'astro',
        'astro-markdown',
        'blade',
        'clojure',
        'django-html',
        'htmldjango',
        'edge',
        'eelixir',
        'elixir',
        'ejs',
        'erb',
        'eruby',
        'gohtml',
        'gohtmltmpl',
        'haml',
        'handlebars',
        'hbs',
        'html',
        'htmlangular',
        'html-eex',
        'heex',
        'jade',
        'leaf',
        'liquid',
        'markdown',
        'mdx',
        'mustache',
        'njk',
        'nunjucks',
        'php',
        'razor',
        'slim',
        'twig',
        'css',
        'less',
        'postcss',
        'sass',
        'scss',
        'stylus',
        'sugarss',
        'javascript',
        'javascriptreact',
        'reason',
        'rescript',
        'typescript',
        'typescriptreact',
        'vue',
        'svelte',
        'templ',
      },
    })

    -- Configure Roslyn language server
    require('roslyn').setup {
      config = {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          vim.bo[bufnr].tabstop = 4
          vim.bo[bufnr].shiftwidth = 4
          vim.bo[bufnr].expandtab = true
          vim.bo[bufnr].softtabstop = 4
          vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertEnter', 'InsertLeave' }, {
            buffer = bufnr,
            callback = function()
              vim.lsp.codelens.refresh { bufnr = 0 }
              -- workaround for diagnostics not being triggered
              client:request('textDocument/diagnostic', {
                textDocument = vim.lsp.util.make_text_document_params(),
              }, nil, bufnr)
            end,
          })
        end,
        filewatching = true,
        settings = {
          ['csharp|inlay_hints'] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
          ['csharp|code_lens'] = {
            dotnet_enable_references_code_lens = true,
          },
        },
      },
    }
    local function format_buffer()
      vim.lsp.buf.format { async = true }
    end

    vim.keymap.set({ 'v', 'n' }, '<leader>la', '<cmd>lua require("fastaction").code_action()<CR>', { desc = 'lsp: code actions' })
    vim.keymap.set('n', '<leader>lf', format_buffer, { desc = 'lsp: format buffer' })
    vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, { desc = 'lsp: diagnostic messages' })
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { desc = 'lsp: rename' })
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'lsp: hover documentation' })
    vim.keymap.set('n', 'gR', vim.lsp.buf.references, { desc = 'lsp: native references' })
    vim.keymap.set('i', '<c-k>', vim.lsp.buf.signature_help, { desc = 'lsp: signature help' })

    -- Enable the server
    vim.lsp.enable { 'lua_ls', 'vtsls', 'cssls', 'gopls', 'tailwindcss', 'eslint', 'jsonls' }
  end,
}
