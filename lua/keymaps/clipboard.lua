-- System clipboard
-- Function to copy yanked text to system clipboard
local function yank_to_clipboard()
  local yanked_text = vim.fn.getreg '"' -- Get the last yanked text
  vim.fn.setreg('+', yanked_text) -- Set the yanked text to the clipboard register
end

-- Command to call the Lua function
vim.api.nvim_create_user_command('Y', yank_to_clipboard, {})

vim.api.nvim_set_keymap('v', '<S-y>', '"+y', { noremap = true, silent = true })

-- Leader Y to yank whole file to clipboard
vim.api.nvim_set_keymap('n', '<leader>y', 'ggVG"+y',
  { noremap = true, silent = true, desc = 'Yank whole file to clipboard' })
-- vim.api.nvim_set_keymap('n', '<leader>y', 'gv"+y', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('v', '<leader>y', '"+y', { noremap = true, silent = true })
