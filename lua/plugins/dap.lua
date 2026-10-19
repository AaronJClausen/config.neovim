return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" }, opts = {} },
      { "theHamsta/nvim-dap-virtual-text", opts = {} },
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP toggle breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "DAP conditional breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "DAP continue" },
      { "<leader>di", function() require("dap").step_into() end, desc = "DAP step into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "DAP step over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "DAP step out" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "DAP REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "DAP run last" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "DAP UI toggle" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "DAP terminate" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

      local codelldb = vim.g.codelldb_path
      if not codelldb then
        if vim.fn.executable("codelldb") == 1 then
          codelldb = vim.fn.exepath("codelldb")
        elseif vim.fn.executable("codelldb.cmd") == 1 then
          codelldb = vim.fn.exepath("codelldb.cmd")
        end
      end

      if codelldb then
        dap.adapters.codelldb = {
          type = "server",
          port = "${port}",
          executable = {
            command = codelldb,
            args = { "--port", "${port}" },
            detached = false,
          },
        }
      end

      dap.configurations.zig = {
        {
          name = "Launch (codelldb)",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/zig-out/bin/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
      }

      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo" })
    end,
  },
}
