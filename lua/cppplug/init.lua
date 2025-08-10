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
  local current_vars = vim.tbl_deep_extend("force", {}, M.opts)
  current_vars.project_name = get_safe_project_name()
  local formatted_content = content:gsub("{{(.-)}}", function(key)
    return tostring(current_vars[key] or "")
  end)
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
  local current_vars = vim.tbl_deep_extend("force", {}, M.opts)
  current_vars.project_name = get_safe_project_name()
  local formatted_content = content:gsub("{{(.-)}}", function(key)
    return tostring(current_vars[key] or "")
  end)
  write_file("CMakeLists.txt", formatted_content)
  vim.notify("Generated C17 CMakeLists.txt in " .. vim.fn.getcwd())
end

function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})

  vim.api.nvim_create_user_command("CMakeListsTxtGenCPP", gen_cpp, {})
  vim.api.nvim_create_user_command("CMakeListsTxtGenC", gen_c, {})

  local function configure_cmake()
    vim.api.nvim_command("sp | terminal cmake -B build -S .")
    vim.api.nvim_command("wincmd p")
  end
  vim.api.nvim_create_user_command("CMakeConfigure", configure_cmake, {})

  local function build_cmake()
    vim.api.nvim_command("sp | terminal cmake --build build")
    vim.api.nvim_command("wincmd p")
  end
  vim.api.nvim_create_user_command("CMakeBuild", build_cmake, {})
end

return M
