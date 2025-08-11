local M = {}

M.opts = {
  default_cpp_standard = 23,
  default_c_standard = 17,
}


local function write_file(path, content)
  local fd = assert(io.open(path, "w"))
  fd:write(content)
  fd:close()
end

local function get_safe_project_name()
  local cwd = vim.fn.getcwd()
  local project_folder_name = vim.fn.fnamemodify(cwd, ":t")
  -- Sanitize the project name: replace spaces with underscores, remove non-alphanumeric (and non-underscore) characters
  project_folder_name = project_folder_name:gsub("%s", "_"):gsub("[^%w_]", "")
  return project_folder_name
end

-- Reusable function to process CMake templates
local function process_cmake_template(template_content)
  local current_vars = vim.tbl_deep_extend("force", {}, M.opts)
  current_vars.project_name = get_safe_project_name()
  local formatted_content = template_content:gsub("{{(.-)}}", function(key)
    return tostring(current_vars[key] or "")
  end)
  return formatted_content
end

function scroll_buffer_to_bottom(buf_id)
  -- Use nvim_buf_call to run commands in the context of the specified buffer
  vim.api.nvim_buf_call(buf_id, function()
    -- Execute the normal mode command 'G' to go to the end of the buffer
    vim.cmd 'normal! G'
  end)
end

local function gen_cpp()
  local content = [[
cmake_minimum_required(VERSION 3.20)
project({{project_name}} LANGUAGES CXX)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD {{default_cpp_standard}})
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_executable({{project_name}} main.cpp)
]]
  local formatted_content = process_cmake_template(content)
  write_file("CMakeLists.txt", formatted_content)
  vim.notify("Generated C++ CMakeLists.txt in " .. vim.fn.getcwd())
end

local function gen_c()
  local content = [[
cmake_minimum_required(VERSION 3.20)
project({{project_name}} LANGUAGES C)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_C_STANDARD {{default_c_standard}})
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

add_executable({{project_name}} main.c)
]]
  local formatted_content = process_cmake_template(content)
  write_file("CMakeLists.txt", formatted_content)
  vim.notify("Generated C17 CMakeLists.txt in " .. vim.fn.getcwd())
end

local function gen_cmake()
  local file_extension = vim.fn.expand('%:e')
  if file_extension == 'cpp' or file_extension == 'hpp' then
    gen_cpp()
  elseif file_extension == 'c' or file_extension == 'h' then
    gen_c()
  else
    vim.notify("Current file is not a C, C++, .h, or .hpp file. Cannot generate CMakeLists.txt", vim.log.levels.ERROR)
  end
end

local function configure_cmake(on_success_cb, on_error_cb)
  local term_buf_nr = vim.api.nvim_create_buf(false, true)

  -- Open a new split window
  vim.cmd('sp')
  local win_id = vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_buf(term_buf_nr)

  vim.fn.termopen('cmake -B build -S .', {
    on_exit = function(job_id, exit_code, event)
      if exit_code == 0 then
        -- Close the specific window if successful
        vim.api.nvim_win_close(win_id, true)
        vim.notify('CMake configure successful, terminal closed.', vim.log.levels.INFO)
        if type(on_success_cb) == 'function' then
          on_success_cb()
        end
      else
        vim.notify('CMake configure failed. Terminal left open for inspection.', vim.log.levels.ERROR)
        scroll_buffer_to_bottom(term_buf_nr)
        if type(on_error_cb) == 'function' then
          on_error_cb()
        end
      end
    end
  })
  scroll_buffer_to_bottom(term_buf_nr)
  -- Return focus to original window
  vim.cmd('wincmd p')
end

local function build_cmake_once(on_success_cb, on_error_cb)
  local term_buf_nr = vim.api.nvim_create_buf(false, true)

  -- Open a new split window
  vim.cmd('sp')
  local win_id = vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_buf(term_buf_nr)

  vim.fn.termopen('cmake --build build', {
    on_exit = function(job_id, exit_code, event)
      if exit_code == 0 then
        -- Close the specific window if successful
        vim.api.nvim_win_close(win_id, true)
        vim.notify('CMake build successful, terminal closed.', vim.log.levels.INFO)
        if type(on_success_cb) == 'function' then
          on_success_cb()
        end
      else
        -- vim.notify('CMake build failed. Terminal left open for inspection.', vim.log.levels.ERROR)
        scroll_buffer_to_bottom(term_buf_nr)
        vim.api.nvim_set_current_win(win_id)
        vim.cmd('startinsert')
        if type(on_error_cb) == 'function' then
          on_error_cb()
        end
      end
    end
  })
  vim.cmd('wincmd p')
  scroll_buffer_to_bottom(term_buf_nr)
  -- Return focus to original window
end

local function setup_new_project(on_success_cb, on_error_cb)
  vim.notify("Generating CMakeLists.txt for project...", vim.log.levels.INFO)
  gen_cmake()

  vim.notify("Configuring CMake project...", vim.log.levels.INFO)
  configure_cmake(
    function(output_path) -- on_success_cb for configure_cmake
      vim.notify("CMake configure successful. Building project...", vim.log.levels.INFO)
      build_cmake_once(
        function() -- on_success_cb for build_cmake_once
          vim.notify("New CMake project setup and build complete!", vim.log.levels.INFO)
          if type(on_success_cb) == 'function' then
            on_success_cb(output_path)
          end
        end,
        function(error_output) -- on_error_cb for build_cmake_once
          vim.notify("CMake build failed. New project setup incomplete.", vim.log.levels.ERROR)
          if type(on_error_cb) == 'function' then
            on_error_cb(error_output)
          end
        end
      )
    end,
    function(error_output) -- on_error_cb for configure_cmake
      vim.notify("CMake configure failed. New project setup incomplete.", vim.log.levels.ERROR)
      if type(on_error_cb) == 'function' then
        on_error_cb(error_output)
      end
    end
  )
end

function M.get_default_executable_name()
  return "build/" .. get_safe_project_name()
end

function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})

  vim.api.nvim_create_user_command("CMakeListsTxtGenCPP", gen_cpp, {})
  vim.api.nvim_create_user_command("CMakeListsTxtGenC", gen_c, {})
  vim.api.nvim_create_user_command("CMakeListsTxtGen", gen_cmake, {})
  vim.api.nvim_create_user_command("CMakeNewProject", function(opts) setup_new_project(opts.fargs[1], opts.fargs[2]) end, { nargs = '*' })

  vim.api.nvim_create_user_command("CMakeConfigure", function(opts) configure_cmake(opts.fargs[1], opts.fargs[2]) end,
    { nargs = '*' })

  local function _run_watchexec_command(command_str, success_message, error_message, should_close_on_success,
                                        on_success_callback)
    local term_buf_nr = vim.api.nvim_create_buf(false, true)

    vim.cmd('sp')
    local win_id = vim.api.nvim_get_current_win()
    vim.api.nvim_set_current_buf(term_buf_nr)

    vim.fn.termopen(command_str, {
      on_exit = function(job_id, exit_code, event)
        print("event: ", vim.inspect(event))
        vim.schedule(function()
          if exit_code == 0 then
            -- vim.notify(success_message, vim.log.levels.INFO)
            if should_close_on_success then
              -- vim.api.nvim_win_close(win_id, true)
              if on_success_callback then
                on_success_callback()
              end
            end
          else
            -- vim.notify(error_message, vim.log.levels.ERROR)
            scroll_buffer_to_bottom(term_buf_nr)
            vim.api.nvim_set_current_win(win_id)
            vim.cmd('startinsert')
          end
        end)
      end
    })
    vim.cmd('wincmd p')
    scroll_buffer_to_bottom(term_buf_nr)
  end

  local function build_watch_cmake()
    _run_watchexec_command(
      [[watchexec -w . -e cpp,c,h,hpp -i 'build/**' -i '.git/**' -i '**/*.sw?' -i '**/*~' -i '**/.#*' -i '**/.DS_Store' -i '**/.cache/**' -i '**/.undo/**' -i '**/spectre*/**' --debounce 200ms -- 'cmake --build build']],
      'Build watcher exited. Terminal closed.',
      'Build watcher exited with errors. Terminal left open for inspection.',
      false -- Don't close on success for watcher
    )
  end
  vim.api.nvim_create_user_command("CMakeBuildWatch", build_watch_cmake, {})

  local function build_and_run_watch_cmake()
    local project_name = get_safe_project_name()
    local executable_path = "build/" .. project_name
    _run_watchexec_command(
      string.format(
        [[watchexec -w . -e cpp,c,h,hpp -i 'build/**' -i '.git/**' -i '**/*.sw?' -i '**/*~' -i '**/.#*' -i '**/.DS_Store' -i '**/.cache/**' -i '**/.undo/**' -i '**/spectre*/**' --debounce 200ms -- fish -c '"cmake --build build && %s"']],
        executable_path
      ),
      'Build and run watcher exited successfully. Terminal closed.',
      'Build and run watcher exited with errors. Terminal left open for inspection.',
      true -- Close on success for build and run
    )
  end
  vim.api.nvim_create_user_command("CMakeBuildAndRunWatch", build_and_run_watch_cmake, {})

  local function build_watch_until_success_cmake(on_success_cb)
    _run_watchexec_command(
      [[watchexec -w . -e cpp,c,h,hpp -i 'build/**' -i '.git/**' -i '**/*.sw?' -i '**/*~' -i '**/.#*' -i '**/.DS_Store' -i '**/.cache/**' -i '**/.undo/**' -i '**/spectre*/**' --debounce 200ms -- cmake --build build]],
      'Build watcher exited successfully after successful build. Terminal closed.',
      'Build watcher exited with errors before successful build. Terminal left open for inspection.',
      true, -- Close on success
      on_success_cb
    )
  end
  vim.api.nvim_create_user_command("CMakeBuildWatchUntilSuccess",
    function(opts) build_watch_until_success_cmake(opts.fargs[1]) end,
    { nargs = '?', complete = 'custom,v:lua.vim.lsp.get_clients' })


  vim.api.nvim_create_user_command("CMakeBuildOnce", function(opts) build_cmake_once(opts.fargs[1], opts.fargs[2]) end,
    { nargs = '*' })
end

M.gen_cpp = gen_cpp
M.gen_c = gen_c
M.gen_cmake = gen_cmake
M.setup_new_project = setup_new_project
M.build_cmake_once = build_cmake_once

return M
