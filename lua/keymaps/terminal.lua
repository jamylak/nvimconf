local M = {}

function M.setup()
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
end

return M
