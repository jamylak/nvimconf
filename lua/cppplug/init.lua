local M = {}

M.opts = {
  cpp_standard = 23, -- default C++ standard
  c_standard = 17,   -- default C standard
  project_name = "MyProject"
}


local function write_file(path, content)
  local fd = assert(io.open(path, "w"))
  fd:write(content)
  fd:close()
end

local function gen_cpp()
  local content = [[
cmake_minimum_required(VERSION 3.20)
project(MyProject LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_executable(${PROJECT_NAME} main.cpp)
]]
  write_file("CMakeLists.txt", content)
  vim.notify("Generated C++23 CMakeLists.txt in " .. vim.fn.getcwd())
end

local function gen_c()
  local content = [[
cmake_minimum_required(VERSION 3.20)
project(MyProject LANGUAGES C)

set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

add_executable(${PROJECT_NAME} main.c)
]]
  write_file("CMakeLists.txt", content)
  vim.notify("Generated C17 CMakeLists.txt in " .. vim.fn.getcwd())
end

function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
  local aug = vim.api.nvim_create_augroup("CppPlug", { clear = true })
  -- -- example autocmd, keep if you want
  -- vim.api.nvim_create_autocmd("BufEnter", {
  --   group = aug,
  --   pattern = "*.cpp,*.hpp,*.cc,*.cxx,*.hh,*.c,*.h",
  --   callback = function() end,
  -- })

  vim.api.nvim_create_user_command("CMakeListsTxtGenCPP", gen_cpp, {})
  vim.api.nvim_create_user_command("CMakeListsTxtGenC", gen_c, {})
end

return M
