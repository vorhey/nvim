---@diagnostic disable: missing-fields
return {
  'williamboman/mason.nvim',
  event = 'VeryLazy',
  dependencies = {
    { 'b0o/schemastore.nvim', lazy = true },
    { 'williamboman/mason-lspconfig.nvim', lazy = true },
    { 'seblj/roslyn.nvim', lazy = true, ft = { 'cs' }, opts = {} },
    { 'luckasRanarison/tailwind-tools.nvim', lazy = true, ft = { 'js', 'jsx', 'ts', 'tsx' } },
    { 'yioneko/nvim-vtsls', lazy = true, ft = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' } },
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
    {
      'nvim-flutter/flutter-tools.nvim',
      lazy = false,
      dependencies = {
        'nvim-lua/plenary.nvim',
      },
      config = true,
    },
    { 'p00f/clangd_extensions.nvim', opts = {} },
  },
  lazy = true,
  config = function()
    -- Mason configuration
    require('mason').setup {
      ui = { delay = 1000 },
      registries = {
        'github:mason-org/mason-registry',
        'github:Crashdummyy/mason-registry',
      },
    }

    -- Mason LSP configuration
    require('mason-lspconfig').setup {
      ensure_installed = {
        'clangd',
        'cssls',
        'dockerls',
        'eslint',
        'gopls',
        'intelephense',
        'jsonls',
        'lua_ls',
        'tailwindcss',
        'vtsls',
        'yamlls',
        'jdtls',
      },
    }

    vim.diagnostic.config {
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅗',
          [vim.diagnostic.severity.WARN] = '',
          [vim.diagnostic.severity.HINT] = '',
          [vim.diagnostic.severity.INFO] = '󰅺',
        },
      },
      underline = false,
      severity_sort = true,
      float = {
        border = 'rounded',
      },
    }

    -- Use default capabilities instead of custom module
    local capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), require('cmp_nvim_lsp').default_capabilities())

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
    require('vtsls').config { refactor_auto_rename = true }
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
    vim.lsp.config('roslyn', {
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
    })

    vim.filetype.add {
      extension = { axaml = 'xml' },
    }

    -- install: https://github.com/eugenenoble2005/avalonia-ls
    -- vim.lsp.config('avalonia', {
    --   cmd = { 'avalonia-ls' },
    --   filetypes = { 'xml' },
    --   root_markers = { '.git', '*.sln', '*.csproj' },
    -- })

    vim.lsp.config('yamlls', {
      cmd = { 'yaml-language-server', '--stdio' },
      filetypes = { 'yml', 'yaml', 'yaml.docker-compose', 'yaml.gitlab' },
      settings = {
        yaml = {
          schemas = {
            ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
            ['../path/relative/to/file.yml'] = '/.github/workflows/*',
            ['/path/from/root/of/project'] = '/.github/workflows/*',
          },
        },
      },
    })

    vim.lsp.config('dockerls', {
      cmd = { 'docker-langserver', '--stdio' },
      filetypes = { 'dockerfile' },
    })

    vim.lsp.config('intelephense', {
      cmd = { 'intelephense', '--stdio' },
      filetypes = { 'php' },
      root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        local cwd = assert(vim.uv.cwd())
        local root = vim.fs.root(fname, { 'composer.json', '.git' })
        on_dir(root and vim.fs.relpath(cwd, root) and cwd)
      end,
    })

    -- Configure flutter
    require('flutter-tools').setup {}
    local function format_buffer()
      vim.lsp.buf.format { async = true }
    end

    -- Configure Java
    vim.lsp.config('jdtls', {
      cmd = {
        'jdtls',
        '--java-executable=' .. (vim.env.JAVA_DEV_HOME or vim.env.JAVA_HOME) .. '/bin/java',
        '--jvm-arg=-javaagent:' .. vim.fn.expand '~/.local/share/nvim/mason/packages/jdtls/lombok.jar',
        '--add-modules=ALL-SYSTEM',
        '--add-opens',
        'java.base/java.util=ALL-UNNAMED',
        '--add-opens',
        'java.base/java.lang=ALL-UNNAMED',
      },
      filetypes = { 'java' },
      root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle', 'build.gradle.kts' },
      init_options = {
        jvm_args = {},
        workspace = vim.fn.expand '~/.cache/jdtls/workspace/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t'),
      },
      settings = {
        java = {
          home = vim.env.JAVA_DEV_HOME or vim.env.JAVA_HOME,
          eclipse = {
            downloadSources = true,
          },
          configuration = {
            updateBuildConfiguration = 'interactive',
            runtimes = vim.env.JAVA_DEV_HOME and {
              {
                name = 'JavaSE-21',
                path = vim.env.JAVA_DEV_HOME,
              },
            } or {},
          },
          maven = {
            downloadSources = true,
          },
          implementationsCodeLens = {
            enabled = true,
          },
          referencesCodeLens = {
            enabled = true,
          },
          references = {
            includeDecompiledSources = true,
          },
          format = {
            enabled = false,
            settings = {
              url = vim.fn.stdpath 'config' .. '/lang-servers/intellij-java-google-style.xml',
              profile = 'GoogleStyle',
            },
          },
          signatureHelp = { enabled = true },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
          codeGeneration = {
            toString = {
              template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
            },
            useBlocks = true,
          },
          completion = {
            favoriteStaticMembers = {
              'org.hamcrest.MatcherAssert.assertThat',
              'org.hamcrest.Matchers.*',
              'org.hamcrest.CoreMatchers.*',
              'org.junit.jupiter.api.Assertions.*',
              'java.util.Objects.requireNonNull',
              'java.util.Objects.requireNonNullElse',
              'org.mockito.Mockito.*',
            },
            importOrder = {
              'java',
              'javax',
              'com',
              'org',
            },
          },
          contentProvider = { preferred = 'fernflower' },
          extendedClientCapabilities = {
            progressReportsSupport = true,
            classFileContentsSupport = true,
            generateToStringPromptSupport = true,
            hashCodeEqualsPromptSupport = true,
            advancedExtractRefactoringSupport = true,
            advancedOrganizeImportsSupport = true,
            generateConstructorsPromptSupport = true,
            generateDelegateMethodsPromptSupport = true,
            moveRefactoringSupport = true,
          },
        },
      },
    })

    -- Configure C/C++ language server
    vim.lsp.config('clangd', {
      cmd = { 'clangd' },
      filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
      root_markers = {
        '.clangd',
        '.clang-tidy',
        '.clang-format',
        'compile_commands.json',
        'compile_flags.txt',
        'configure.ac',
        '.git',
      },
      settings = {
        clangd = {
          arguments = {
            '--background-index',
            '--clang-tidy',
            '--header-insertion=iwyu',
            '--completion-style=detailed',
            '--function-arg-placeholders',
            '--fallback-style=llvm',
          },
        },
      },
    })

    vim.keymap.set({ 'v', 'n' }, '<leader>la', '<cmd>lua require("fastaction").code_action()<CR>', { desc = 'lsp: code actions' })
    vim.keymap.set('n', '<leader>lf', format_buffer, { desc = 'lsp: format buffer' })
    vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, { desc = 'lsp: diagnostic messages' })
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { desc = 'lsp: rename' })
    vim.keymap.set({ 'n', 'v' }, 'K', vim.lsp.buf.hover, { desc = 'lsp: hover documentation' })
    vim.keymap.set('n', 'gR', vim.lsp.buf.references, { desc = 'lsp: native references' })
    vim.keymap.set('i', '<c-k>', vim.lsp.buf.signature_help, { desc = 'lsp: signature help' })

    -- Enable the server
    vim.lsp.enable {
      -- 'avalonia',
      'clangd',
      'cssls',
      'dockerls',
      'eslint',
      'gopls',
      'intelephense',
      'jsonls',
      'lua_ls',
      'tailwindcss',
      'vtsls',
      'yamlls',
    }
  end,
}
