vim.api.nvim_set_keymap('v', '<leader><leader>r', ':lua ExecuteVisualSelectionAsLua()<CR>',
  { noremap = true, desc = 'Execute lua' })
vim.api.nvim_set_keymap('n', '<leader><leader>s', ':source %<CR>', { noremap = true, desc = '[S]ource Lua File' })

-- Keymapping to run code inside of a visual selection
-- using :lua (visually selected code)
function ExecuteVisualSelectionAsLua()
  -- Save the original cursor position
  local save_cursor = vim.api.nvim_win_get_cursor(0)
  -- Get the current visual selection boundaries
  local _, start_line, _, _ = unpack(vim.fn.getpos "'<")
  local _, end_line, _, _ = unpack(vim.fn.getpos "'>")
  -- Adjust the line numbers for correct indexing
  start_line = start_line - 1
  end_line = end_line
  -- Capture the text within the visual selection
  local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
  local code_to_execute = table.concat(lines, '\n')
  -- Execute the captured Lua code
  local func = load(code_to_execute)
  if func then
    pcall(func)
  else
    print 'Error in the selected Lua code.'
  end
  -- Restore the cursor position
  vim.api.nvim_win_set_cursor(0, save_cursor)
end
