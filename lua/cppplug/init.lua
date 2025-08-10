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

local function setup_new_project_cpp()
  local success, err = pcall(function()
    vim.notify("Generating CMakeLists.txt for C++ project...", vim.log.levels.INFO)
    gen_cpp()

    vim.notify("Configuring CMake project...", vim.log.levels.INFO)
    vim.api.nvim_command("CMakeConfigure")

    -- vim.notify("Building CMake project...", vim.log.levels.INFO)
    -- vim.api.nvim_command("CMakeBuild")

    vim.notify("New C++ CMake project setup complete!", vim.log.levels.INFO)
  end)

  if not success then
    vim.notify("C++ CMake project setup failed: " .. tostring(err), vim.log.levels.ERROR)
  end
end

local function setup_new_project_c()
  local success, err = pcall(function()
    vim.notify("Generating CMakeLists.txt for C project...", vim.log.levels.INFO)
    gen_c()

    vim.notify("Configuring CMake project...", vim.log.levels.INFO)
    vim.api.nvim_command("CMakeConfigure")

    -- vim.notify("Building CMake project...", vim.log.levels.INFO)
    -- vim.api.nvim_command("CMakeBuild")

    vim.notify("New C CMake project setup complete!", vim.log.levels.INFO)
  end)

  if not success then
    vim.notify("C CMake project setup failed: " .. tostring(err), vim.log.levels.ERROR)
  end
end

function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})

  vim.api.nvim_create_user_command("CMakeListsTxtGenCPP", gen_cpp, {})
  vim.api.nvim_create_user_command("CMakeListsTxtGenC", gen_c, {})
  vim.api.nvim_create_user_command("CMakeNewProjectCPP", setup_new_project_cpp, {})
  vim.api.nvim_create_user_command("CMakeNewProjectC", setup_new_project_c, {})

  local function configure_cmake()
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
        else
          vim.notify('CMake configure failed. Terminal left open for inspection.', vim.log.levels.ERROR)
          scroll_buffer_to_bottom(term_buf_nr)
        end
      end
    })
    scroll_buffer_to_bottom(term_buf_nr)
    -- Return focus to original window
    vim.cmd('wincmd p')
  end
  vim.api.nvim_create_user_command("CMakeConfigure", configure_cmake, {})

  local function build_cmake()
    local term_buf_nr = vim.api.nvim_create_buf(false, true)

    vim.cmd('sp')                                 -- Open a new split window
    local win_id = vim.api.nvim_get_current_win() -- Capture the window ID
    vim.api.nvim_set_current_buf(term_buf_nr)

    vim.fn.termopen(
      [[watchexec -w . -e cpp,c,h,hpp -i 'build/**' -i '.git/**' -i '**/*.sw?' -i '**/*~' -i '**/.#*' -i '**/.DS_Store' -i '**/.cache/**' -i '**/.undo/**' -i '**/spectre*/**' --debounce 200ms -- cmake --build build]],
      {
        on_exit = function(job_id, exit_code, event)
          -- The watchexec process has exited, so we can notify the user and close the window
          vim.schedule(function()
            vim.notify('Build watcher exited. Terminal closed.', vim.log.levels.INFO)
            vim.api.nvim_win_close(win_id, true)
          end)
        end
      })
    vim.cmd('wincmd p') -- Return focus to original window
    scroll_buffer_to_bottom(term_buf_nr)
  end
  vim.api.nvim_create_user_command("CMakeBuild", build_cmake, {})
end

M.gen_cpp = gen_cpp
M.gen_c = gen_c

return M
