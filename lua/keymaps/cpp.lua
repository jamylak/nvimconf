-- Switch from header file to source file and vice versa
-- This is useful when you are working with C/C++ projects
-- For example if I'm in include/abc.h it will go to src/abc.cpp
-- If I'm in src/abc.cpp it will go to include/abc.h
vim.api.nvim_create_user_command('S', function()
  local file_path = vim.fn.expand '%:p:h'
  local file_name = vim.fn.expand '%:t'
  local new_file_path = ''
  local new_file_name = ''
  if file_path:match 'include' then
    new_file_path = file_path:gsub('include', 'src')
  elseif file_path:match 'src' then
    new_file_path = file_path:gsub('src', 'include')
  else
    new_file_path = file_path
  end
  if file_name:match '%.cpp' then
    new_file_name = file_name:gsub('%.cpp', '.h')
  elseif file_name:match '%.h' then
    new_file_name = file_name:gsub('%.h', '.cpp')
  end
  new_file_path = new_file_path .. '/' .. new_file_name
  vim.cmd('e ' .. new_file_path)
end, {})
