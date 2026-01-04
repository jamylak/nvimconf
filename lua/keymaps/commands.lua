vim.keymap.set('n', '<leader>m', ':make<CR>', { silent = true, desc = 'Run [M]ake' })
vim.keymap.set('n', '<leader>q', ':q!<CR>', { silent = true })
vim.keymap.set('n', '<leader>Q', ':qall!<CR>', { silent = true })
vim.keymap.set('n', 'Q', ':qall!<CR>', { silent = true })

-- Faster write
-- Only with function it doesn't come up as double write
vim.keymap.set('n', '<leader>w', function()
  vim.cmd 'w'
end, { silent = true })

vim.api.nvim_create_user_command('WQ', function()
  vim.cmd 'wq!'
end, {})
vim.api.nvim_create_user_command('Q', function()
  vim.cmd 'qall!'
end, {})
