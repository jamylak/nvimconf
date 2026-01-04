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

-- Ctrl Insert key combos
-- vim.keymap.set('i', '<C-j>', '<c-o>w', { silent = true })
-- vim.keymap.set('i', '<C-d>', '<c-o>b', { silent = true })
vim.keymap.set('i', '<C-s>', '<c-o>^', { silent = true })
vim.keymap.set('i', '<C-h>', '<c-o><leader>w', { silent = true })
vim.keymap.set('i', '<C-y>', '<C-r>+', { silent = true })

-- Paste with alt m
vim.keymap.set('i', '<a-m>', '<C-r>+', { silent = true })
vim.keymap.set('n', '<a-m>', '"+p', { silent = true })
vim.keymap.set('v', '<a-m>', '"+p', { silent = true })
-- Faster way to do common symbols
-- vim.keymap.set('i', '<C-i><C-i>', ',', { silent = true })
vim.keymap.set('i', '<C-9>', ',', { silent = true, noremap = true })
vim.keymap.set('i', '<C-0>', '.', { silent = true, noremap = true })
vim.keymap.set('i', '<C-i>', ';', { silent = true, noremap = true })
vim.keymap.set('i', '<C-->', ';', { silent = true, noremap = true })

vim.keymap.set('i', '<C-f>', '<Right>', { silent = true })
vim.keymap.set('i', '<C-a>', '<Home>', { silent = true })
vim.keymap.set('i', '<C-e>', '<End>', { silent = true })
vim.keymap.set('i', '<C-b>', '<Left>', { silent = true })
vim.keymap.set('i', '<C-p>', '<Up>', { silent = true })
vim.keymap.set('i', '<C-n>', '<Down>', { silent = true })
vim.keymap.set('i', '<C-d>', '<Del>', { silent = true })
vim.keymap.set('i', '<A-b>', '<c-o>b', { silent = true })
vim.keymap.set('i', '<A-f>', '<c-o>w', { silent = true })
vim.keymap.set('i', '<A-d>', '<c-o>dw', { silent = true })
vim.keymap.set('i', '<C-/>', '<c-o>u', { silent = true })
vim.keymap.set('i', '<C-S-/>', '<c-o><C-r>', { silent = true })
vim.keymap.set('i', '<C-v>', '<PageDown>', { silent = true })
vim.keymap.set('i', '<A-S-[>', '<C-o>{', { silent = true })
vim.keymap.set('i', '<A-S-]>', '<C-o>}', { silent = true })
vim.keymap.set('i', '<A-S-,>', '<C-o>go', { silent = true })
vim.keymap.set('i', '<A-S-.>', '<Esc>G$a', { silent = true })
