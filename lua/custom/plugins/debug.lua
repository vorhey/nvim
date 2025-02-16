---@diagnostic disable: missing-fields
return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
  },
  lazy = true,
  keys = {
    { '<leader>dc', desc = 'debug: start/continue' },
    { '<leader>dn', desc = 'debug: step over' },
    { '<leader>ds', desc = 'debug: stop' },
    { '<leader>dt', desc = 'debug: terminate' },
    { '<leader>db', desc = 'debug: toggle breakpoint' },
    { '<leader>dB', desc = 'debug: conditional breakpoint' },
    { '<leader>di', desc = 'debug: toggle interface' },
    { '<leader>dr', desc = 'debug: clear breakpoints' },
  },
  config = function()
    local dap = require 'dap'
    dap.set_log_level 'DEBUG'
    local dapui
    local utils = require 'utils'

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

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        'coreclr',
        'delve',
        'js',
      },
    }

    -- Keymaps helper functions
    local breakpoint_condition = function()
      dap.set_breakpoint(vim.fn.input 'Debug: Breakpoint Condition: ')
    end
    local toggle_dap_ui = function()
      setup_dapui()
      dapui.toggle()
    end
    -- Keymaps
    vim.keymap.set('n', '<leader>dc', dap.continue)
    vim.keymap.set('n', '<leader>dn', dap.step_over)
    vim.keymap.set('n', '<leader>ds', dap.close)
    vim.keymap.set('n', '<leader>dt', dap.terminate)
    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint)
    vim.keymap.set('n', '<leader>dB', breakpoint_condition)
    vim.keymap.set('n', '<leader>di', toggle_dap_ui)
    vim.keymap.set('n', '<leader>dr', dap.clear_breakpoints)

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
          return utils.pick_file('*.dll', { 'obj/.*' })
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
          return utils.pick_file('*.json', { 'obj/.*' })
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
        name = 'Debug',
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
