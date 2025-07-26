return {
  'rcarriga/nvim-dap-ui',
  dependencies = {
    'mfussenegger/nvim-dap',
    'nvim-neotest/nvim-nio',
  },
  config = function()
    local dap, dapui = require 'dap', require 'dapui'

    dapui.setup()

    -- dap.listeners.after.event_initialized['dapui_config'] = function()
    --   dapui.open()
    -- end
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
  },
}
