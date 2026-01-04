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
vim.keymap.set('n', '<C-\\>', function()
  vim.cmd ':split | term'
  vim.cmd 'startinsert'
end, { silent = true, desc = 'Vertical Split' })
vim.keymap.set('n', '<C-S-\\>', function()
  vim.cmd ':vsplit | term'
  vim.cmd 'startinsert'
end, { silent = true, desc = 'Horizontal Split' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { silent = true })
vim.keymap.set('t', '90w', '<C-W>', { silent = true })

vim.api.nvim_set_keymap('n', '<leader><leader>v', ':vsplit | term fish -c "cb; rn;"<CR>',
  { noremap = true, desc = '[c]make build and run vertical ' })

vim.api.nvim_create_user_command('TT', terminalNewTab, {})
vim.api.nvim_create_user_command('TV', terminalVertical, {})
vim.api.nvim_create_user_command('TH', terminalHorizontal, {})
-- Custom command to start a new terminal with tmux attach
vim.api.nvim_create_user_command('TA', function()
  vim.cmd 'new | term tmux a'
end, {})

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

local function find_terminal_buffer_number()
  -- Get the current tabpage
  local tabpage = vim.api.nvim_get_current_tabpage()
  -- Get all windows in the current tabpage
  local windows = vim.api.nvim_tabpage_list_wins(tabpage)

  for _, window in ipairs(windows) do
    -- Get the buffer number for each window
    local buf = vim.api.nvim_win_get_buf(window)
    -- Get the buffer type
    local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
    -- Check if the buffer type is terminal
    if buftype == 'terminal' then
      return buf
    end
  end

  return nil -- Return nil if no terminal buffer is found
end

local function scroll_buffer_to_bottom(buf_id)
  -- Use nvim_buf_call to run commands in the context of the specified buffer
  vim.api.nvim_buf_call(buf_id, function()
    -- Execute the normal mode command 'G' to go to the end of the buffer
    vim.cmd 'normal! G'
  end)
end

local function sendTerminalRepeat(initialCommand)
  -- First send a write command to write current file
  vim.cmd 'write'
  -- Then find the open terminal buffer in the current tab
  local terminal_buffer = find_terminal_buffer_number()
  if terminal_buffer ~= nil then
    local chan = vim.api.nvim_buf_get_var(terminal_buffer, 'terminal_job_id')
    -- Now send the keys to the terminal
    if chan then
      if initialCommand then
        vim.fn.chansend(chan, initialCommand)
      else
        vim.fn.chansend(chan, 'r\r')
      end
      scroll_buffer_to_bottom(terminal_buffer)
    end
  else
    -- If no terminal is open, open one
    local bufname = vim.api.nvim_buf_get_name(0)
    local cmd = nil
    vim.cmd 'split | term'

    -- We can't run
    --      vim.cmd('split | term fish -c "' .. cmd .. '"; exec fish')
    --  cmd = 'python3 ' .. bufname
    -- Cause then it won't easily repeat the last command
    if bufname:match '%.py$' then
      -- Switch back to the original window
      vim.cmd 'wincmd p'
      cmd = 'python3 ' .. bufname .. ' \r'
      -- print('Initial Command set to: ' .. cmd)
      -- If we don't wait 100 ms then it sends the command but it
      -- doesn't run
      vim.defer_fn(function()
        sendTerminalRepeat(cmd)
      end, 220)
    else
      vim.cmd 'startinsert'
    end
  end
end

vim.api.nvim_create_user_command('M', sendTerminalRepeat, {})
-- TODO: Something where it will launch a Watch and Run below?
-- vim.api.nvim_create_user_command('WatchAndRun', sendTerminalRepeat, {})
vim.keymap.set('n', '<leader>n', sendTerminalRepeat, { desc = 'Send Repeat to terminal' })
