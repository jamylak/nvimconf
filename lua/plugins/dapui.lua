local function ensure_dap_config()
  local config_dir = vim.fn.getcwd() .. "/.nvim"
  local config_file = config_dir .. "/dap.lua"

  -- Create directory if missing
  if not vim.loop.fs_stat(config_dir) then
    vim.fn.mkdir(config_dir, "p")
  end

  -- Write template if file missing
  if not vim.loop.fs_stat(config_file) then
    local template = [[
return {
--   python = {
--     args = { "--domains", "example.com", "--debug" },
--     justMyCode = false,
--     stopOnEntry = true,
--     pythonPath = function()
--       return ".venv/bin/python3"
--     end,
--   },
--   cpp = {
--     args = { "--log-level", "trace" },
--     program = "build/main",
--     initCommands = { "breakpoint set --name main" },
--   },
--   rust = {
--     args = { "--port", "8080" }
--   }
}
]]
    local fd = assert(io.open(config_file, "w"))
    fd:write(template)
    fd:close()
    vim.notify("Created DAP config template at " .. config_file, vim.log.levels.INFO)
  end
end

local function load_dap_project_config(lang)
  ensure_dap_config()
  local config_path = vim.fn.getcwd() .. "/.nvim/dap.lua"
  local ok, config = pcall(dofile, config_path)
  if not ok or type(config) ~= "table" then
    return {}
  end
  return config[lang] or {}
end

local function setup_python_dapui_layouts()
  require('dapui').setup({
    layouts = { {
      elements = { {
        id = "scopes",
        size = 0.25
      }, {
        id = "breakpoints",
        size = 0.25
      }, {
        id = "stacks",
        size = 0.25
      }, {
        id = "watches",
        size = 0.25
      } },
      position = "left",
      size = 40
    }, {
      elements = {
        {
          id = "repl",
          size = 1.0
        },
      },
      position = "bottom",
      size = 10
    } },
  })
end



local function setup_cpp_dapui_layouts()
  require('dapui').setup({
    layouts = { {
      elements = { {
        id = "scopes",
        size = 0.25
      }, {
        id = "breakpoints",
        size = 0.25
      }, {
        id = "stacks",
        size = 0.25
      }, {
        id = "watches",
        size = 0.25
      } },
      position = "left",
      size = 40
    }, {
      elements = {
        {
          id = "repl",
          size = 0.5
        },
        {
          id = "disassembly",
          size = 0.5,
        },
      },
      position = "bottom",
      size = 10
    } },
  })
end
local function launch_python_debugger()
  local dap = require('dap')
  local breakpoints = require('dap.breakpoints')
  local cwd = vim.fn.getcwd() -- Define cwd here

  -- TODO: Config could turn this off
  local cur_bufnr = vim.api.nvim_get_current_buf()
  local last_line = vim.fn.line('$')
  breakpoints.set({}, cur_bufnr, last_line)

  local cfg = load_dap_project_config("python")
  local dapui = require('dapui')

  -- Check if a session is active
  if dap.session() then
    -- Register a one-time listener
    local function on_terminated()
      dap.listeners.after.event_terminated["restart_and_run_python"] = nil
      vim.notify("✅ Old DAP session terminated, launching new debugger", vim.log.levels.INFO)
      setup_python_dapui_layouts()

      dap.run({
        type = 'python',
        request = 'launch',
        name = 'Autopilot',
        program = cfg.program or vim.fn.expand('%'), -- current file
        args = cfg.args or {},
        justMyCode = cfg.justMyCode or false,
        cwd = cfg.cwd or cwd,
        stopOnEntry = cfg.stopOnEntry or false,
        pythonPath = cfg.pythonPath or function()
          return vim.fn.filereadable('.venv/bin/python3') == 1 and '.venv/bin/python3' or 'python3'
        end,
        initCommands = cfg.initCommands or {}
      })
      pcall(dapui.open)
    end

    dap.listeners.after.event_terminated["restart_and_run_python"] = on_terminated
    vim.notify("⏳ Terminating previous DAP session...", vim.log.levels.WARN)
    dap.terminate()
  else
    vim.notify("✅ Launching debugger", vim.log.levels.INFO)
    setup_python_dapui_layouts()

    dap.run({
      type = 'python',
      request = 'launch',
      name = 'Autopilot',
      program = cfg.program or vim.fn.expand('%'), -- current file
      args = cfg.args or {},
      justMyCode = cfg.justMyCode or false,
      cwd = cfg.cwd or cwd,
      stopOnEntry = cfg.stopOnEntry or false,
      pythonPath = cfg.pythonPath or function()
        return vim.fn.filereadable('.venv/bin/python3') == 1 and '.venv/bin/python3' or 'python3'
      end,
      initCommands = cfg.initCommands or {}
    })
    pcall(dapui.open)
  end
end

local function launch_c_cpp_debugger()
  local dap = require('dap')
  local dapui = require('dapui')
  local cppplug = require('cppplug')
  local cwd = vim.fn.getcwd()

  local function on_build_success()
    vim.notify("✅ Build succeeded, launching debugger", vim.log.levels.INFO)

    local cfg = load_dap_project_config("cpp")

    -- Define the config you want to launch
    local config = {
      name = "Launch compiled .out",
      type = "lldb",
      request = "launch",
      program = cfg.program or cppplug.get_default_executable_name(),
      cwd = cfg.cwd or cwd,
      stopOnEntry = cfg.stopOnEntry or false,
      args = cfg.args or {},
      initCommands = cfg.initCommands or { "breakpoint set --name main" }
    }
    setup_cpp_dapui_layouts()

    -- Check if a session is active
    if dap.session() then
      -- Register a one-time listener
      local function on_terminated()
        dap.listeners.after.event_terminated["restart_and_run"] = nil
        vim.notify("✅ Old DAP session terminated, launching new debugger", vim.log.levels.INFO)
        dap.run(config)
        pcall(dapui.open)
      end

      dap.listeners.after.event_terminated["restart_and_run"] = on_terminated
      vim.notify("⏳ Terminating previous DAP session...", vim.log.levels.WARN)
      dap.terminate()
    else
      vim.notify("✅ Launching debugger", vim.log.levels.INFO)
      dap.run(config)
      pcall(dapui.open)
    end
  end

  local function on_build_failure(error_output)
    vim.notify("❌ Build failed\n" .. error_output, vim.log.levels.ERROR)
  end

  -- Check if CMakeLists.txt exists
  if vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
    cppplug.build_cmake_once_debug(on_build_success, on_build_failure)
  else
    cppplug.setup_new_project(on_build_success, on_build_failure)
  end
end

local function dispatch_dap_launch()
  local filetype = vim.bo.filetype
  if filetype == 'python' then
    launch_python_debugger()
  elseif filetype == 'cpp' or filetype == 'c' then
    launch_c_cpp_debugger()
  else
    vim.notify("No debugger configured for filetype: " .. filetype, vim.log.levels.WARN)
  end
end


return {
  'rcarriga/nvim-dap-ui',
  dependencies = {
    'mfussenegger/nvim-dap',
    'nvim-neotest/nvim-nio',
    'Jorenar/nvim-dap-disasm',
    "rcarriga/cmp-dap",
  },
  config = function()
    local dap, dapui = require 'dap', require 'dapui'

    require('nvim-dap-virtual-text').setup({
      commented = true
    })

    require("dap-disasm").setup({})
    -- Setup DAP REPL with cmp autocomplete
    local cmp = require 'cmp'
    cmp.setup {
      -- Normally, nvim-cmp disables itself inside "prompt" buffers to avoid interfering with UIs like Telescope prompts.
      -- But the DAP REPL is a "prompt" buffer — and we do want completions there.
      -- So this line re-enables it only when the buffer is related to debugging.
      enabled = function()
        return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
            or require("cmp_dap").is_dap_buffer()
      end,
    }

    cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
      sources = {
        { name = "dap" },
      },
    })

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
  -- icons = {},
  -- mappings = {},
  -- element_mappings = {},
  -- expand_lines = false,
  -- force_buffers = false,
  -- floating = {},
  -- controls = {},
  -- render = {},
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
      '<leader>GC',
      function()
        require('dap').continue()
      end,
      desc = 'Continue Debugging',
    },
    -- Idea: A version of this which just runs through nokrmally
    -- no isntant break? -- maybe
    --
    -- TODO: Need another keymap when there is eg.
    -- project wide cmake
    -- or eg. just a very custom build command
    -- test different debugs on large projects etc until there is
    -- a reliable way
    {
      '<leader>GJ',
      function()
        dispatch_dap_launch()
      end,
      desc = 'Launch Debugger (Python/C++)',
    },
    {
      '<leader>c',
      function()
        dispatch_dap_launch()
      end,
      desc = 'Launch Debugger (Python/C++)',
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
      '<leader>GX',
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
