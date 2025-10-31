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

    local function setup_dapui()
      if not dapui then
        dapui = require 'dapui'
        dapui.setup {
          controls = {
            enabled = false,
          },
          layouts = {
            {
              elements = {
                { id = 'scopes', size = 0.5 },
                { id = 'watches', size = 0.5 },
              },
              position = 'bottom',
              size = 10,
            },
          },
          render = {
            max_value_lines = 1,
          },
        }
      end
    end

    -- Keymaps helper functions
    local breakpoint_condition = function()
      dap.set_breakpoint(vim.fn.input 'Debug: Breakpoint Condition: ')
    end
    local toggle_dap_ui = function()
      setup_dapui()
      dapui.toggle()
    end
    -- Keymaps
    vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'debug: start/continue (F5)' })
    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'debug: start/continue (F5)' })
    vim.keymap.set('n', '<leader>dn', dap.step_over, { desc = 'debug: step over (F10)' })
    vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'debug: step over (F10)' })
    vim.keymap.set('n', '<leader>ds', dap.close, { desc = 'debug: stop' })
    vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = 'debug: terminate (F6)' })
    vim.keymap.set('n', '<F6>', dap.terminate, { desc = 'debug: terminate (F6)' })
    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'debug: toggle breakpoint (F9)' })
    vim.keymap.set('n', '<F9>', dap.toggle_breakpoint, { desc = 'debug: toggle breakpoint (F9)' })
    vim.keymap.set('n', '<leader>dB', breakpoint_condition, { desc = 'debug: conditional breakpoint' })
    vim.keymap.set('n', '<leader>di', toggle_dap_ui, { desc = 'debug: toggle interface' })
    vim.keymap.set('n', '<leader>dr', dap.clear_breakpoints, { desc = 'debug: clear breakpoints' })

    -- Debuggers Setup
    -- c#
    dap.adapters.coreclr = {
      type = 'executable',
      command = vim.fn.stdpath 'data' .. '/mason/bin/netcoredbg',
      args = { '--interpreter=vscode' },
      options = {
        detached = false,
      },
    }
    dap.configurations.cs = {
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
            -- todo: request input from ui
            return 'Development'
          end,
          ASPNETCORE_URLS = function()
            -- todo: request input from ui
            return 'http://localhost:5283'
          end,
        },
        cwd = function()
          return utils.pick_file('json', { 'obj/.*' })
        end,
      },
    }
    dap.adapters.go = {
      type = 'server',
      port = '${port}',
      executable = {
        command = vim.fn.stdpath 'data' .. '/mason/bin/dlv',
        args = { 'dap', '-l', '127.0.0.1:${port}' },
      },
    }

    dap.configurations.go = {
      {
        type = 'go',
        name = 'Debug workspace',
        request = 'launch',
        program = '${workspaceFolder}',
      },
      {
        type = 'go',
        name = 'Debug file',
        request = 'launch',
        program = '${file}',
      },
      {
        type = 'go',
        name = 'Debug test',
        request = 'launch',
        mode = 'test',
        program = '${file}',
      },

      {
        type = 'go',
        name = 'Debug test (go.mod)',
        request = 'launch',
        mode = 'test',
        program = './${relativeFileDirname}',
      },
    }

    dap.adapters['pwa-node'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = 'js-debug-adapter',
        args = {
          '${port}',
        },
      },
    }
    dap.adapters['pwa-chrome'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = 'js-debug-adapter',
        args = {
          '${port}',
        },
      },
    }

    -- C/C++ (clang/gcc) debugger using lldb or gdb
    dap.adapters.codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb',
        args = { '--port', '${port}' },
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

    for _, lang in ipairs { 'typescript', 'typescriptreact', 'javascript' } do
      dap.configurations[lang] = {
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
          skipFiles = {
            '<node_internals>/**',
            '${workspaceFolder}/node_modules/**',
          },
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
          resolveSourceMapLocations = {
            '${workspaceFolder}/**',
            '!**/node_modules/.pnpm/**',
          },
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch TypeScript File (tsx installed locally)',
          runtimeExecutable = '${workspaceFolder}/node_modules/.bin/tsx',
          args = { '${file}' },
          cwd = '${workspaceFolder}',
          sourceMaps = true,
          resolveSourceMapLocations = {
            '${workspaceFolder}/**',
            '!**/node_modules/.pnpm/**',
          },
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
          resolveSourceMapLocations = {
            '${workspaceFolder}/**',
            '!**/node_modules/.pnpm/**',
          },
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
    end

    vim.fn.sign_define('DapBreakpoint', {
      text = '',
      texthl = 'DapBreakpoint',
      linehl = '',
      numhl = 'DapBreakpoint',
    })

    vim.fn.sign_define('DapBreakpointRejected', {
      text = '󰥔',
      texthl = '',
      linehl = '',
      numhl = '',
    })

    vim.fn.sign_define('DapLogPoint', {
      text = '',
      texthl = 'DapLogPoint',
      linehl = 'DapLogPoint',
      numhl = 'DapLogPoint',
    })

    vim.fn.sign_define('DapStopped', {
      text = '',
      texthl = 'DapStopped',
      linehl = 'DapStopped',
      numhl = 'DapStopped',
    })

    -- DAP UI open/close based on events
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
