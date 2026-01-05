return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
  },
  cmd = {
    'DapContinue',
    'DapStepInto',
    'DapStepOver',
    'DapStepOut',
    'DapTerminate',
    'DapToggleBreakpoint',
    'DapSetBreakpoint',
    'DapClearBreakpoints',
    'DapListBreakpoints',
    'DapToggleRepl',
    'DapRunToCursor',
    -- TODO: one to toggle breakpoint with a condition
    -- eg. =require('dap').set_breakpoint("key == 96")
  },
  config = function()
    if vim.loop.os_uname().sysname ~= 'Darwin' then
      return
    end

    local dap = require 'dap'

    -- https://github.com/mfussenegger/nvim-dap-python/blob/65ccab83fb3d0b29ead6c765c1c52a1ed49592e8/lua/dap-python.lua#L136
    -- Do i need to use this plugin?
    dap.adapters.python = function(cb, config)
      if config.request == 'attach' then
        ---@diagnostic disable-next-line: undefined-field
        local port = (config.connect or config).port
        ---@diagnostic disable-next-line: undefined-field
        local host = (config.connect or config).host or '127.0.0.1'
        cb({
          type = 'server',
          port = assert(port, '`connect.port` is required for a python `attach` configuration'),
          host = host,
          options = {
            source_filetype = 'python',
          }
        })
      else
        cb({
          type = 'executable',
          command = "python3",
          args = { '-m', 'debugpy.adapter' },
          options = {
            source_filetype = 'python',
          }
        })
      end
    end

    dap.adapters.lldb = {
      type = 'executable',
      command = '/opt/homebrew/opt/llvm/bin/lldb-dap',
      name = 'lldb',
    }

    -- dap.adapters.codelldb = {
    --   type = 'executable',
    --   command = '/usr/local/bin/codelldb',
    --   name = 'codelldb',
    -- }

    local pythonPath = function()
      -- TODO: Needs to be from root of github?? maybe maybe not
      local venv_python_local = '.venv/bin/python3'
      local venv_python = vim.fn.getcwd() .. '/' .. venv_python_local
      local default_python = vim.fn.filereadable(venv_python) == 1 and venv_python_local or 'python3'
      return vim.fn.input('Path to python: ', default_python, 'file')
    end

    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch (stop on entry)',
        program = '${file}',
        stopOnEntry = true,
        pythonPath = pythonPath,
      },
      {
        type = 'python',
        request = 'launch',
        name = 'Launch (no stop)',
        program = '${file}',
        stopOnEntry = false,
        pythonPath = pythonPath,
      },
    }

    dap.configurations.cpp = {
      {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
          return coroutine.create(function(coro)
            local cwd = vim.fn.getcwd()
            local current_file = vim.fn.expand('%:t:r') -- filename without extension
            local candidate = cwd .. '/' .. current_file .. '.out'
            local candidate_short = current_file .. '.out'

            -- TODO: Just make this show first? Instead of filling path in?
            local default_path = vim.fn.filereadable(candidate) == 1 and candidate_short or ""
            -- print('Default path:', default_path)

            require('telescope.pickers').new({}, {
              prompt_title = 'Select Executable',
              finder = require('telescope.finders').new_oneshot_job(
                { 'fd', '--type', 'x', '--no-ignore', '--exec-batch', 'realpath' },
                { cwd = cwd }
              ),
              sorter = require('telescope.config').values.generic_sorter({}),
              default_text = default_path,
              attach_mappings = function(prompt_bufnr, _)
                local actions = require('telescope.actions')
                local action_state = require('telescope.actions.state')

                actions.select_default:replace(function()
                  actions.close(prompt_bufnr)
                  local entry = action_state.get_selected_entry()
                  coroutine.resume(coro, entry[1])
                end)

                return true
              end,
            }):find()
          end)
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        initCommands = {
          "breakpoint set --name main",
        },
        args = {},
      },
    }
    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp
  end,
  lazy = true,
  -- event = 'VeryLazy',
  -- ft = { 'cpp', 'c', 'rust' }, -- Only load for these filetypes
}
