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

function fuzzsan_template()
  return [[
option(ENABLE_SANITIZERS "Build with sanitizers" OFF)
option(ENABLE_FUZZING "Build fuzz targets" OFF)

if (ENABLE_SANITIZERS)
  add_compile_options(-fsanitize=address,undefined -fno-omit-frame-pointer -g)
  add_link_options(-fsanitize=address,undefined)
endif()

if (ENABLE_FUZZING)
  add_executable(fuzz_target fuzz.cpp)
  target_compile_options(fuzz_target PRIVATE -fsanitize=fuzzer,address,undefined -O1 -g)
  target_link_options(fuzz_target PRIVATE -fsanitize=fuzzer,address,undefined)
endif()

]]

  -- todo: memory, thread as well?
end

local function gen_cpp(filename)
  filename = filename or "main.cpp"
  local content = [[
cmake_minimum_required(VERSION 3.20)
project({{project_name}} LANGUAGES CXX)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD {{default_cpp_standard}})
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_executable(${PROJECT_NAME} ]] .. filename .. [[)

# Recommended warnings and safeguards
target_compile_options(${PROJECT_NAME} PRIVATE
  -Wall -Wextra -Wpedantic -Werror
  -Wshadow -Wnon-virtual-dtor -Wold-style-cast -Wcast-align -Wunused
  -Woverloaded-virtual -Wconversion -Wsign-conversion -Wmisleading-indentation
  -Wnull-dereference -Wdouble-promotion -Wformat=2
)
]]
  local formatted_content = fuzzsan_template() .. process_cmake_template(content)
  write_file("CMakeLists.txt", formatted_content)
  vim.notify("Generated C++ CMakeLists.txt in " .. vim.fn.getcwd())

  --- TODO : Add sanitizers and fuzzing options for C & CPP
end

local function gen_c(filename)
  filename = filename or "main.c"
  local content = [[
cmake_minimum_required(VERSION 3.20)
project({{project_name}} LANGUAGES C)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_C_STANDARD {{default_c_standard}})
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

add_executable(${PROJECT_NAME} ]] .. filename .. [[)

# Recommended warnings and safeguards
target_compile_options(${PROJECT_NAME} PRIVATE
  -Wall -Wextra -Wpedantic -Werror -Wshadow -Wcast-align -Wunused
  -Wconversion -Wsign-conversion -Wnull-dereference -Wdouble-promotion
  -Wformat=2
)
]]
  local formatted_content = process_cmake_template(content)
  write_file("CMakeLists.txt", formatted_content)
  vim.notify("Generated C17 CMakeLists.txt in " .. vim.fn.getcwd())
end

local function setupGit()
  -- 1. Setup .gitignore
  -- Add build to .gitignore if it exists
  -- else create it with build entry
  local gitignore_path = ".gitignore"
  local gitignore_exists = vim.fn.filereadable(gitignore_path) == 1
  if gitignore_exists then
    -- TODO: update to search for it first before adding to the end
    -- Just add it to the end
    -- local gitignore_file = io.open(gitignore_path, "a")
    -- if gitignore_file then
    --   gitignore_file:write("\nbuild/\n")
    --   gitignore_file:close()
    --   vim.notify("Added 'build/' to existing .gitignore", vim.log.levels.INFO
    --   )
    -- else
    --   vim.notify("Failed to open .gitignore for appending", vim.log.levels.ERROR)
    -- end
  else
    -- Create a new .gitignore file
    -- with build entry
    -- and common ignores
    local gitignore_file = io.open(gitignore_path, "w")
    if gitignore_file then
      gitignore_file:write([[
# Ignore build directory
build/
# Ignore common temporary files
*.swp
*~
.DS_Store
.cache/
.undo/
]])
      gitignore_file:close()
      vim.notify("Created new .gitignore with 'build/' entry", vim.log.levels.INFO)
    else
      vim.notify("Failed to create .gitignore", vim.log.levels.ERROR)
    end
  end

  -- 2. Now run git init if not already a git repo
  local git_dir = ".git"
  local git_repo_exists = vim.fn.isdirectory(git_dir) == 1
  if not git_repo_exists then
    -- Make sure output doesn't pullute nvim
    local init_command = "git init > /dev/null 2>&1"
    local result = os.execute(init_command)
    if result == 0 then
      vim.notify("Initialized new Git repository", vim.log.levels.INFO)
    else
      vim.notify("Failed to initialize Git repository", vim.log.levels.ERROR)
    end
  end
end

local function gen_cmake()
  local file_extension = vim.fn.expand('%:e')
  local filename = vim.fn.expand('%:t')
  if file_extension == 'cpp' then
    gen_cpp(filename)
    setupGit()
  elseif file_extension == 'c' then
    gen_c(filename)
    setupGit()
  else
    vim.notify("Current file is not a C, C++, .h, or .hpp file. Cannot generate CMakeLists.txt", vim.log.levels.ERROR)
  end
end

local function configure_cmake(on_success_cb, on_error_cb, build_type)
  -- TODO: Support configure or build in current dir eg. for tests/
  build_type = build_type or "" -- Default to empty string
  local term_buf_nr = vim.api.nvim_create_buf(false, true)

  -- Open a new split window
  vim.cmd('sp')
  local win_id = vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_buf(term_buf_nr)

  local cmake_command = 'cmake -G Ninja -B build -S . -DCMAKE_EXPORT_COMPILE_COMMANDS=ON'
  if build_type ~= "" then
    cmake_command = cmake_command .. ' -DCMAKE_BUILD_TYPE=' .. build_type
  end

  vim.fn.termopen(cmake_command, {
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
          scroll_buffer_to_bottom(term_buf_nr)
          vim.api.nvim_set_current_win(win_id)
          vim.cmd('startinsert')
          -- TODO: Test proper error pass through?
          on_error_cb(event)
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
          on_success_cb(M.get_default_executable_name())
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

local function configure_and_build_cmake_once_debug(on_success_cb, on_error_cb)
  configure_cmake(
    function()
      build_cmake_once(on_success_cb, on_error_cb)
    end,
    on_error_cb,
    "Debug"
  )
end

local function setup_new_project(on_success_cb, on_error_cb)
  -- Setup a new project, with debug on
  vim.notify("Generating CMakeLists.txt for project...", vim.log.levels.INFO)
  gen_cmake()

  vim.notify("Configuring CMake project...", vim.log.levels.INFO)
  configure_cmake(
    function() -- configure_cmake doesn't return output_path
      vim.notify("CMake configure successful. Building project...", vim.log.levels.INFO)
      build_cmake_once(
        function(output_path) -- build_cmake_once now returns output_path
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
    end,
    "Debug"
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
  vim.api.nvim_create_user_command("CMakeNewProject", function(opts) setup_new_project(opts.fargs[1], opts.fargs[2]) end,
    { nargs = '*' })

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

  vim.api.nvim_create_user_command("CMakeConfigureAndBuildOnceDebug",
    function(opts) configure_and_build_cmake_once_debug(opts.fargs[1], opts.fargs[2]) end,
    { nargs = '*' })
end

M.gen_cpp = gen_cpp
M.gen_c = gen_c
M.gen_cmake = gen_cmake
M.setup_new_project = setup_new_project
M.build_cmake_once = build_cmake_once
M.configure_and_build_cmake_once_debug = configure_and_build_cmake_once_debug

return M
