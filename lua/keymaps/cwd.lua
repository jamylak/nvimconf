local function changeDir()
  local file_path = vim.fn.expand '%:p'
  local dir_path = vim.fn.fnamemodify(file_path, ':h')
  vim.api.nvim_set_current_dir(dir_path)
end

local function changeDirWindow()
  local file_path = vim.fn.expand '%:p'
  local dir_path = vim.fn.fnamemodify(file_path, ':h')
  vim.cmd('lcd ' .. dir_path)
end

local function changeDirTab()
  local file_path = vim.fn.expand '%:p'
  local dir_path = vim.fn.fnamemodify(file_path, ':h')
  vim.cmd('tcd ' .. dir_path)
end

-- vim.keymap.set('n', 'cd', changeDir, { desc = 'Change [C]urrent [D]irectory to parent of curfile' })
vim.keymap.set('n', 'cd', changeDirTab, { desc = 'Tab Change [C]urrent [D]irectory to parent of curfile' })
vim.keymap.set('n', '<leader>tc', changeDirTab, { desc = '[T]ab Change [C]urrent Directory to parent of curfile' })
vim.keymap.set('n', '<leader>lc', changeDirWindow, { desc = 'Window Change [C]urrent Directory to parent of curfile' })
