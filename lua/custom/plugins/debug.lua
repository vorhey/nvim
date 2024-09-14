---@diagnostic disable: missing-fields
-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',
    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',
    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'mxsdev/nvim-dap-vscode-js',
    {
      'microsoft/vscode-js-debug',
      opt = true,
      build = 'npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out',
    },
    {
      'folke/neodev.nvim',
      opts = {
        library = { plugins = { 'nvim-dap-ui' }, types = true },
      },
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'coreclr',
        'delve',
      },
    }

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<leader>dn', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>ds', dap.close, { desc = 'Debug: Stop' })
    vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = 'Debug: Terminate' })
    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>dB', function()
      dap.set_breakpoint(vim.fn.input 'Debug: Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<leader>di', dapui.toggle, { desc = 'Debug: Toggle Interface' })

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
          return vim.fn.input('Entry point: ', vim.fn.getcwd() .. '/', 'file')
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
          return vim.fn.input('appsettings.json: ', vim.fn.getcwd() .. '/', 'file')
        end,
      },
    }

    -- go
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
        name = 'Debug test', -- configuration for debugging test files
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

    -- typescript
    require('dap-vscode-js').setup {
      debugger_path = vim.fn.stdpath 'data' .. '/lazy/vscode-js-debug', -- Path to vscode-js-debug installation.
      adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
      log_file_path = vim.fn.stdpath 'cache' .. '/dap_vscode_js.log', -- Path for file logging
      log_file_level = vim.log.levels.DEBUG, -- Logging level for output to file. Set to false to disable file logging.
    }
    dap.configurations.typescript = {
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
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        enabled = true,
      },
      layouts = {
        {
          elements = {
            {
              id = 'scopes',
              size = 0.60, -- Increased from 0.25 to 0.40
            },
            {
              id = 'breakpoints',
              size = 0.20, -- Adjusted to maintain total of 1.0
            },
            {
              id = 'watches',
              size = 0.20, -- Adjusted to maintain total of 1.0
            },
          },
          position = 'left',
          size = 40,
        },
      },
    }

    vim.fn.sign_define('DapBreakpoint', {
      text = '',
      texthl = 'DapBreakpoint',
      linehl = '',
      numhl = 'DapBreakpoint',
    })

    vim.fn.sign_define('DapBreakpointRejected', {
      text = '',
      texthl = 'DapBreakpoint',
      linehl = 'DapBreakpoint',
      numhl = 'DapBreakpoint',
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

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
  end,
}
