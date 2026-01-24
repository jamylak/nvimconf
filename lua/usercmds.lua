vim.api.nvim_create_user_command('LeftMargin', function()
  vim.cmd('vnew')
  vim.cmd('wincmd H')
  vim.cmd('vertical resize 30')
  vim.cmd('wincmd W')
end, { desc = 'Create an empty vertical split to the left of the current window' })

vim.api.nvim_create_user_command('FindFiles', function()
  vim.schedule(function()
    vim.cmd 'Telescope find_files'
  end)
end, { desc = 'Open Telescope find_files after UI is ready' })

vim.api.nvim_create_user_command('FindWord', function()
  vim.schedule(function()
    require('telescope.builtin').live_grep()
  end)
end, { desc = 'Open Telescope live_grep after UI is ready' })
