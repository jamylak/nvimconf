local function terminal()
  vim.cmd 'term!'
  vim.cmd 'startinsert'
end

local function terminalNewTab()
  vim.cmd '-tabnew | term'
  vim.cmd 'startinsert'
end

local function terminalVertical()
  vim.cmd 'vsplit | term'
  vim.cmd 'startinsert'
end

local function terminalHorizontal()
  vim.cmd 'split | term'
  vim.cmd 'startinsert'
end

vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = 'New Tab' })
vim.keymap.set('n', '<a-t>', ':split<CR><C-w>T', { desc = 'New Tab' })
vim.keymap.set('n', '<c-t>', ':tabnew<CR>', { desc = 'New Tab' })
vim.keymap.set('n', '<leader>te', terminal, { desc = ':term' })
vim.keymap.set('n', '<leader>tk', terminal, { desc = ':term' })
vim.keymap.set('n', '<leader>tt', terminalNewTab, { desc = 'Terminal - New Tab' })
vim.keymap.set('n', '<S-CR>', terminalNewTab, { desc = 'Terminal - New Tab' })
vim.keymap.set('n', '<leader>tv', terminalVertical, { desc = 'Terminal - Vertical' })
vim.keymap.set('n', '<leader>tj', terminalVertical, { desc = 'Terminal - Vertical' })
vim.keymap.set('n', '<leader>th', terminalHorizontal, { desc = 'Terminal - Horizontal' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { silent = true })

-- Allow jk and ji escape in terminal mode but not in yazi or lazygit
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = '*',
  callback = function()
    if not vim.api.nvim_buf_get_name(0):match 'yazi' and not vim.api.nvim_buf_get_name(0):match 'lazygit' then
      vim.keymap.set('t', 'jk', '<C-\\><C-n>', { buffer = true, silent = true })
      vim.keymap.set('t', 'ji', '<C-\\><C-n>', { buffer = true, silent = true })
    end
  end,
})
