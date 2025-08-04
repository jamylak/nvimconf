return {
  'rcarriga/nvim-dap-ui',
  dependencies = {
    'mfussenegger/nvim-dap',
    'nvim-neotest/nvim-nio',
  },
  config = function()
    local dap, dapui = require 'dap', require 'dapui'

    require('nvim-dap-virtual-text').setup({
      -- commented = true
    })
    dapui.setup()

    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    -- dap.listeners.before.event_terminated['dapui_config'] = function()
    --   dapui.close()
    -- end
    -- dap.listeners.before.event_exited['dapui_config'] = function()
    --   dapui.close()
    -- end
  end,
  keys = {
    {
      '<leader>GG', -- or any key you want
      function()
        require('dapui').toggle()
      end,
      desc = 'Toggle DAP UI',
    },
    {
      '<leader>GB',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Toggle Breakpoint',
    },
    {
      '<leader>GC',
      function()
        require('dap').continue()
      end,
      desc = 'Continue Debugging',
    },
    {
      '<leader>GJ',
      function()
        -- Compile and then debug
        -- Default compile command for now
        -- assuming C++
        -- g++ -g -O0 {cur_file}.cpp -std=c++23 -o {cur_file}.out
        local current_file = vim.fn.expand('%:t:r') -- filename without extension
        local compile_command = string.format(
          'g++ -g -O0 %s.cpp -std=c++23 -o %s.out', current_file, current_file
        )
        local output_path = vim.fn.expand('%:p:h') .. '/' .. current_file .. '.out'
        local cwd = vim.fn.getcwd()
        local stdout_lines = {}
        local stderr_lines = {}

        -- 🛠 Run compilation
        vim.fn.jobstart(compile_command, {
          stdout_buffered = true,
          stderr_buffered = true,

          on_stdout = function(_, data)
            if data then
              vim.list_extend(stdout_lines, data)
            end
          end,

          on_stderr = function(_, data)
            if data then
              vim.list_extend(stderr_lines, data)
            end
          end,

          on_exit = function(_, exit_code)
            if exit_code ~= 0 then
              if #stdout_lines > 0 then
                local output = table.concat(stdout_lines, '\n')
                vim.notify(output, vim.log.levels.INFO)
              end

              if #stderr_lines > 0 then
                local error_output = "❌ Compilation failed\n" .. table.concat(stderr_lines, '\n')
                vim.notify(error_output, vim.log.levels.ERROR)
              end
            else
              vim.notify("✅ Compilation succeeded, launching debugger", vim.log.levels.INFO)

              -- 🚀 Start DAP with compiled binary
              require('dap').run({
                name = "Launch compiled .out",
                type = "lldb",
                request = "launch",
                program = output_path,
                cwd = cwd,
                stopOnEntry = false,
                args = {},
                initCommands = {
                  "breakpoint set --name main"
                }
              })

              -- Optional: open dap-ui if available
              pcall(require('dapui').open)
            end
          end,
        })
      end,
      desc = 'Compile and Debug',
    },
    {
      '<leader>GN',
      function()
        require('dap').step_over()
      end,
      desc = 'Step Over',
    },
    {
      '<leader>GI',
      function()
        require('dap').step_into()
      end,
      desc = 'Step Into',
    },
    {
      '<leader>GO',
      function()
        require('dap').step_out()
      end,
      desc = 'Step Out',
    },
    {
      '<leader>GR',
      function()
        require('dap').run_to_cursor()
      end,
      desc = 'Run to Cursor',
    },
    {
      '<leader>GQ',
      function()
        require('dap').restart()
      end,
      desc = 'Restart Debugging',
    },
    {
      '<leader>Gx',
      function()
        require('dap').terminate()
      end,
      desc = 'Terminate Debugging',
    },
    {
      '<leader>Ge',
      function()
        require('dap.ui.widgets').hover()
      end,
      desc = 'Evaluate Expression',
    },
  },
}
