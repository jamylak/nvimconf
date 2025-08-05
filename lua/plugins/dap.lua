return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
  },
  config = function()
    if vim.loop.os_uname().sysname ~= 'Darwin' then
      return
    end

    local dap = require 'dap'

    dap.adapters.lldb = {
      type = 'executable',
      command = '/opt/homebrew/opt/llvm/bin/lldb-dap', -- You can override this if it's installed elsewhere
      name = 'lldb',
    }

    -- Python adapter
    dap.adapters.python = {
      type = 'executable',
      command = 'python3',
      args = { '-m', 'debugpy.adapter' },
    }

    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        stopOnEntry = true,
        pythonPath = function()
          # TODO: Needs to be from root of github?? maybe maybe not
          local venv_python_local = '.venv/bin/python3'
          local venv_python = vim.fn.getcwd() .. '/' .. venv_python_local
          local default_python = vim.fn.filereadable(venv_python) == 1 and venv_python_local or 'python3'
          return vim.fn.input('Path to python: ', default_python, 'file')
        end,
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
                { 'fd', '--type', 'x', '--exec-batch', 'realpath' },
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
