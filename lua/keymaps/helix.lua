local function openCurrentFileInHelix()
  local filename = vim.fn.expand '%:p'
  local line_number = vim.fn.line '.'
  local escaped_filename = "'" .. filename .. "'"
  local helix_cmd = 'hx_new_tab ' .. escaped_filename .. ' ' .. line_number
  local cmd = 'fish -c "' .. helix_cmd .. '"'
  print(cmd)
  vim.fn.system(cmd)
end

vim.keymap.set('n', '<leader><leader>y', ':let @+ = expand("%:p")<CR>',
  { desc = 'Yank filename to clipboard', noremap = true, silent = true })
vim.keymap.set('n', '<leader>Y', openCurrentFileInHelix, { desc = 'Open current file in helix' })
vim.keymap.set('n', '<leader>H', openCurrentFileInHelix, { desc = 'Open current file in helix' })
vim.keymap.set('n', '<leader><leader>Y', openCurrentFileInHelix, { desc = 'Open current file in helix' })
