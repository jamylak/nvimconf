-- Load dap config from project root
-- e.g. .nvim/dap.lua
-- eg. to put some custom args
-- Example:
--
-- ✨ Example .nvim/dap-config.lua (Per Project)
-- return {
--   python = {
--     args = { "--domains", "example.com", "--debug" },
--     pythonPath = function()
--       return ".venv/bin/python3"
--     end,
--   },
--   cpp = {
--     args = { "--log-level", "trace" },
--     stopOnEntry = true,
--     initCommands = { "breakpoint set --name main" },
--   },
--   rust = {
--     args = { "--port", "8080" }
--   }
-- }
--
--
-- In terms of layout setup
-- Console never gets used so don't bother with it
-- elements = { {
--     id = "repl",
--     size = 0.5
--   }, {
--     id = "console",
--     size = 0.5
--   } },

local function load_dap_project_config(lang)
  local config_path = vim.fn.getcwd() .. "/.nvim/dap.lua"
  local ok, config = pcall(dofile, config_path)
  if not ok or type(config) ~= "table" then
    return {}
  end
  return config[lang] or {}
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
    {
      '<leader>GK',
      function()
        -- NOTE: This seems to be able to run to
        -- end without needing to terminate stuff
        local dap = require('dap')
        local breakpoints = require('dap.breakpoints')
        local cwd = vim.fn.getcwd() -- Define cwd here

        -- TODO: Config could turn this off
        local cur_bufnr = vim.api.nvim_get_current_buf()
        local last_line = vim.fn.line('$')
        breakpoints.set({}, cur_bufnr, last_line)

        local cfg = load_dap_project_config("python")
        local dapui = require('dapui')
        -- local dapui = require('dapui') -- Already defined at the top of the config block
        -- local dap = require('dap') -- Already defined at the top of the config block

        -- TODO: Fix issue it can't be calld twice

        -- Check if a session is active
        if dap.session() then
          -- Register a one-time listener
          local function on_terminated()
            dap.listeners.after.event_terminated["restart_and_run_python"] = nil
            vim.notify("✅ Old DAP session terminated, launching new debugger", vim.log.levels.INFO)
            dapui.setup({
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
          dapui.setup({
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
      end,
      desc = 'Debug current file (no stop, no prompt)'
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

              local dap = require('dap')
              local dapui = require('dapui')

              -- TODO: handle C or Rust should be easy to just adjust
              -- the below string
              local cfg = load_dap_project_config("cpp")

              -- Define the config you want to launch
              local config = {
                name = "Launch compiled .out",
                type = "lldb",
                request = "launch",
                program = cfg.output_path or output_path,
                cwd = cfg.cwd or cwd,
                -- Note for cpp this fails cause it probably stops
                -- on _start so you'd wanna do the breakpoint set change
                stopOnEntry = cfg.stopOnEntry or false,
                args = cfg.args or {},
                initCommands = cfg.initCommands or { "breakpoint set --name main" }
              }
              dapui.setup({
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
