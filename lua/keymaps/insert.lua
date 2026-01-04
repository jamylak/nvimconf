-- vim.keymap.set('i', '<C-k>', '<c-o>D', { silent = true })
-- Define the Lua function to handle the key mapping logic
local function check_and_delete()
  local col = vim.fn.col '.'
  local line = vim.fn.getline '.'
  if col <= #line then
    -- If the cursor is not at the end of the line, delete the characters after the cursor
    return '<C-o>D'
  else
    -- If the cursor is at the end of the line, join with the next line
    return '<C-o>J'
  end
end

-- Set the key mapping for Ctrl-K in insert mode
vim.keymap.set('i', '<C-k>', check_and_delete, { expr = true, noremap = true })
