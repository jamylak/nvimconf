local M = require("cppplug")

-- Mock vim functions
local original_getcwd = vim.fn.getcwd
local original_fnamemodify = vim.fn.fnamemodify
local original_notify = vim.notify
local original_io_open = io.open

local mock_written_content = nil
local mock_open_path = nil

local mock_file_descriptor = {
  write = function(self, content)
    mock_written_content = content
  end,
  close = function(self) end,
}

local function setup_mocks(project_name)
  vim.fn.getcwd = function() return "/some/path/" .. project_name end
  vim.fn.fnamemodify = function(path, modifier)
    if modifier == ":t" then
      return project_name
    end
    return original_fnamemodify(path, modifier)
  end
  vim.notify = function(msg, ...) end -- Suppress notifications during tests
  io.open = function(path, mode)
    if mode == "w" then
      mock_open_path = path
      return mock_file_descriptor
    end
    return original_io_open(path, mode)
  end
  M.opts.default_cpp_standard = 23
  M.opts.default_c_standard = 17
end

local function teardown_mocks()
  vim.fn.getcwd = original_getcwd
  vim.fn.fnamemodify = original_fnamemodify
  vim.notify = original_notify
  io.open = original_io_open
  mock_written_content = nil
  mock_open_path = nil
end

local function assert_equal(expected, actual, message)
  if expected ~= actual then
    print("\nFAIL: " .. message)
    print("  Expected:\n" .. expected)
    print("  Actual:\n" .. actual)
    return false
  else
    print("PASS: " .. message)
    return true
  end
end

print("Running cppplug template generation tests...")

-- Test Case 1: gen_cpp template generation
do
  local test_project_name = "MyAwesomeCppProject"
  setup_mocks(test_project_name)
  M.gen_cpp() -- Call the function to be tested

  local expected_content = string.format([[
cmake_minimum_required(VERSION 3.20)
project(%s LANGUAGES CXX)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD %d)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_executable(%s main.cpp)
]], test_project_name, M.opts.default_cpp_standard, test_project_name)

  assert_equal("CMakeLists.txt", mock_open_path, "gen_cpp writes to CMakeLists.txt")
  assert_equal(expected_content, mock_written_content, "gen_cpp generates correct C++ CMakeLists.txt")

  teardown_mocks()
end

-- Test Case 2: gen_c template generation
do
  local test_project_name = "MySimpleCProject"
  setup_mocks(test_project_name)
  M.gen_c() -- Call the function to be tested

  local expected_content = string.format([[
cmake_minimum_required(VERSION 3.20)
project(%s LANGUAGES C)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_C_STANDARD %d)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

add_executable(%s main.c)
]], test_project_name, M.opts.default_c_standard, test_project_name)

  assert_equal("CMakeLists.txt", mock_open_path, "gen_c writes to CMakeLists.txt")
  assert_equal(expected_content, mock_written_content, "gen_c generates correct C CMakeLists.txt")

  teardown_mocks()
end

print("Finished cppplug template generation tests.")

