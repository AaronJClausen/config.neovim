return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'theHamsta/nvim-dap-virtual-text',
      'mason-org/mason.nvim', -- codelldb is installed via mason-tool-installer (see lsp.lua)
    },
    keys = {
      { '<F5>', function() require('dap').continue() end, desc = 'Debug: Start/Continue' },
      { '<F10>', function() require('dap').step_over() end, desc = 'Debug: Step over' },
      { '<F11>', function() require('dap').step_into() end, desc = 'Debug: Step into' },
      { '<S-F11>', function() require('dap').step_out() end, desc = 'Debug: Step out' },
      { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Toggle breakpoint' },
      {
        '<leader>dB',
        function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end,
        desc = 'Conditional breakpoint',
      },
      { '<leader>dc', function() require('dap').continue() end, desc = 'Start/Continue' },
      { '<leader>dt', function() require('dap').terminate() end, desc = 'Terminate session' },
      { '<leader>du', function() require('dapui').toggle() end, desc = 'Toggle debug UI' },
      { '<leader>dr', function() require('dap').repl.toggle() end, desc = 'Toggle REPL' },
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      dapui.setup()
      require('nvim-dap-virtual-text').setup {}

      -- Open/close the UI automatically with the debug session
      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      -- codelldb adapter (installed by mason)
      local codelldb = vim.fn.stdpath 'data' .. '/mason/packages/codelldb/extension/adapter/codelldb'
      if vim.fn.has 'win32' == 1 then
        codelldb = codelldb .. '.exe'
      end
      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = codelldb,
          args = { '--port', '${port}' },
        },
      }

      dap.configurations.zig = {
        {
          name = 'Launch zig-out binary',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/zig-out/bin/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
        },
      }
    end,
  },
}
