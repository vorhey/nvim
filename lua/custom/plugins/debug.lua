---@diagnostic disable: missing-fields
return {
  'mfussenegger/nvim-dap',
  dependencies = {
    { 'williamboman/mason.nvim' },
    { 'rcarriga/nvim-dap-ui' },
    { 'nvim-neotest/nvim-nio' },
  },
  keys = {
    { '<leader>dc', desc = 'debug: start/continue <F5>' },
    { '<leader>dn', desc = 'debug: step over <F10>' },
    { '<leader>ds', desc = 'debug: stop' },
    { '<leader>dt', desc = 'debug: terminate <F6>' },
    { '<leader>db', desc = 'debug: toggle breakpoint <F9>' },
    { '<leader>dB', desc = 'debug: conditional breakpoint' },
    { '<leader>di', desc = 'debug: toggle interface' },
    { '<leader>dr', desc = 'debug: clear breakpoints' },
  },
  config = function()
    local dap = require 'dap'
    local dapui
    local utils = require 'utils'

    -- DAP LOG LEVEL
    dap.set_log_level 'DEBUG'

    -- Simplified DAP UI setup
    local function setup_dapui()
      if not dapui then
        dapui = require 'dapui'
        dapui.setup {
          controls = { enabled = false },
          layouts = {
            {
              elements = {
                { id = 'scopes', size = 0.33 },
                { id = 'watches', size = 0.33 },
                { id = 'repl', size = 0.33 },
              },
              position = 'left',
              size = 50,
            },
          },
          render = { max_value_lines = 1 },
        }
      end
    end

    -- Unified keymaps setup
    local keymaps = {
      { '<leader>dc', dap.continue, 'debug: start/continue (F5)' },
      { '<F5>', dap.continue, 'debug: start/continue (F5)' },
      { '<leader>dn', dap.step_over, 'debug: step over (F10)' },
      { '<F10>', dap.step_over, 'debug: step over (F10)' },
      { '<leader>ds', dap.close, 'debug: stop' },
      { '<leader>dt', dap.terminate, 'debug: terminate (F6)' },
      { '<F6>', dap.terminate, 'debug: terminate (F6)' },
      { '<leader>db', dap.toggle_breakpoint, 'debug: toggle breakpoint (F9)' },
      { '<F9>', dap.toggle_breakpoint, 'debug: toggle breakpoint (F9)' },
      {
        '<leader>dB',
        function()
          dap.set_breakpoint(vim.fn.input 'Debug: Breakpoint Condition: ')
        end,
        'debug: conditional breakpoint',
      },
      {
        '<leader>di',
        function()
          setup_dapui()
          dapui.toggle()
        end,
        'debug: toggle interface',
      },
      { '<leader>dr', dap.clear_breakpoints, 'debug: clear breakpoints' },
    }

    for _, map in ipairs(keymaps) do
      vim.keymap.set('n', map[1], map[2], { desc = map[3] })
    end

    -- Debuggers configuration
    local debuggers = {
      -- C# debugger
      cs = {
        adapter = {
          type = 'executable',
          command = vim.fn.stdpath 'data' .. '/mason/bin/netcoredbg',
          args = { '--interpreter=vscode' },
          options = { detached = false },
        },
        configurations = {
          {
            type = 'coreclr',
            name = 'console - netcoredbg',
            request = 'launch',
            program = function()
              return utils.pick_file('dll', { 'obj/.*' })
            end,
          },
          {
            type = 'coreclr',
            name = 'aspnetcore - netcoredbg',
            request = 'launch',
            program = function()
              return vim.fn.input('Entry Point: ', vim.fn.getcwd() .. '/', 'file')
            end,
            env = {
              ASPNETCORE_ENVIRONMENT = function()
                return 'Development'
              end,
              ASPNETCORE_URLS = function()
                return 'http://localhost:5283'
              end,
            },
            cwd = function()
              return utils.pick_file('json', { 'obj/.*' })
            end,
          },
        },
      },

      -- Go debugger
      go = {
        adapter = {
          type = 'server',
          port = '${port}',
          executable = {
            command = vim.fn.stdpath 'data' .. '/mason/bin/dlv',
            args = { 'dap', '-l', '127.0.0.1:${port}' },
          },
        },
        configurations = {
          { type = 'go', name = 'Debug file', request = 'launch', program = '${file}' },
          { type = 'go', name = 'Debug workspace', request = 'launch', program = '${workspaceFolder}' },
          { type = 'go', name = 'Debug test', request = 'launch', mode = 'test', program = '${file}' },
          { type = 'go', name = 'Debug test (go.mod)', request = 'launch', mode = 'test', program = './${relativeFileDirname}' },
        },
      },

      -- Node.js debuggers
      node = {
        adapter = {
          type = 'server',
          host = 'localhost',
          port = '${port}',
          executable = {
            command = 'js-debug-adapter',
            args = { '${port}' },
          },
        },
      },

      chrome = {
        adapter = {
          type = 'server',
          host = 'localhost',
          port = '${port}',
          executable = {
            command = 'js-debug-adapter',
            args = { '${port}' },
          },
        },
      },

      -- C/C++ debugger
      codelldb = {
        adapter = {
          type = 'server',
          port = '${port}',
          executable = {
            command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb',
            args = { '--port', '${port}' },
          },
        },
      },

      -- Python debugger
      python = {
        adapter = {
          type = 'executable',
          command = vim.fn.stdpath 'data' .. '/mason/bin/debugpy-adapter',
          args = {},
        },
      },
    }

    -- Apply debugger configurations
    dap.adapters.coreclr = debuggers.cs.adapter
    dap.configurations.cs = debuggers.cs.configurations
    dap.adapters.go = debuggers.go.adapter
    dap.configurations.go = debuggers.go.configurations
    dap.adapters['pwa-node'] = debuggers.node.adapter
    dap.adapters['pwa-chrome'] = debuggers.chrome.adapter
    dap.adapters.codelldb = debuggers.codelldb.adapter
    dap.adapters.python = debuggers.python.adapter

    -- Python configurations
    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        pythonPath = function()
          local venv_path = os.getenv 'VIRTUAL_ENV'
          return venv_path and venv_path .. '/bin/python' or 'python'
        end,
      },
      {
        type = 'python',
        request = 'launch',
        name = 'Launch module',
        module = function()
          return vim.fn.input 'Module: '
        end,
      },
      {
        type = 'python',
        request = 'launch',
        name = 'Launch test',
        module = 'unittest',
        args = { '-v', '${file}' },
      },
    }

    -- C/C++ configurations
    dap.configurations.c = {
      {
        name = 'Launch (codelldb)',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
      },
      {
        name = 'Launch with args (codelldb)',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = function()
          local args_string = vim.fn.input 'Arguments: '
          return vim.split(args_string, ' ')
        end,
      },
      {
        name = 'Attach to process (codelldb)',
        type = 'codelldb',
        request = 'attach',
        pid = function()
          return tonumber(vim.fn.input 'Process ID: ')
        end,
      },
      {
        name = 'Build and Launch (codelldb)',
        type = 'codelldb',
        request = 'launch',
        program = function()
          local source_file = vim.fn.expand '%:p'
          local executable = vim.fn.expand '%:p:r'
          local compile_cmd = string.format('clang++ -std=c++20 -g -O0 -o "%s" "%s"', executable, source_file)
          local result = vim.fn.system(compile_cmd)

          if vim.v.shell_error ~= 0 then
            vim.notify('Compilation failed: ' .. result, vim.log.levels.ERROR)
            return nil
          end

          return executable
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
      },
    }

    -- Copy C configurations to C++
    dap.configurations.cpp = dap.configurations.c

    -- JavaScript/TypeScript configurations
    local js_configs = {
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch TypeScript File (bunx tsx)',
        program = '${file}',
        runtimeExecutable = 'bunx',
        runtimeArgs = { 'tsx', '--no-cache', '--no-warnings', '${file}' },
        cwd = '${workspaceFolder}',
        sourceMaps = true,
        resolveSourceMapLocations = { '${workspaceFolder}/**', '!**/node_modules/**' },
        skipFiles = { '<node_internals>/**', '${workspaceFolder}/node_modules/**' },
        console = 'integratedTerminal',
      },
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch TypeScript File (ts-node installed locally)',
        runtimeArgs = { '--require', 'ts-node/register' },
        runtimeExecutable = 'node',
        args = { '${file}' },
        cwd = '${workspaceFolder}',
        sourceMaps = true,
        resolveSourceMapLocations = { '${workspaceFolder}/**', '!**/node_modules/.pnpm/**' },
      },
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch TypeScript File (tsx installed locally)',
        runtimeExecutable = '${workspaceFolder}/node_modules/.bin/tsx',
        args = { '${file}' },
        cwd = '${workspaceFolder}',
        sourceMaps = true,
        resolveSourceMapLocations = { '${workspaceFolder}/**', '!**/node_modules/.pnpm/**' },
      },
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch TypeScript File (swc-node installed locally)',
        runtimeExecutable = 'node',
        runtimeArgs = { '--require', '@swc-node/register' },
        args = { '${file}' },
        cwd = '${workspaceFolder}',
        sourceMaps = true,
        resolveSourceMapLocations = { '${workspaceFolder}/**', '!**/node_modules/.pnpm/**' },
      },
      {
        type = 'pwa-chrome',
        name = 'Launch Chrome',
        request = 'launch',
        url = function()
          local port = vim.fn.input('Port: ', '5173')
          return 'http://localhost:' .. port
        end,
        webRoot = '${workspaceFolder}/src',
      },
    }

    for _, lang in ipairs { 'typescript', 'typescriptreact', 'javascript' } do
      dap.configurations[lang] = js_configs
    end

    -- DAP signs
    local dap_signs = {
      DapBreakpoint = { text = '', texthl = 'DapBreakpoint', numhl = 'DapBreakpoint' },
      DapBreakpointRejected = { text = '󰥔' },
      DapLogPoint = { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' },
      DapStopped = { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' },
    }

    for sign, config in pairs(dap_signs) do
      vim.fn.sign_define(sign, config)
    end

    -- DAP UI event handlers
    dap.listeners.after.event_initialized['dapui_config'] = function()
      setup_dapui()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      if dapui then
        dapui.close()
      end
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      if dapui then
        dapui.close()
      end
    end
  end,
}
