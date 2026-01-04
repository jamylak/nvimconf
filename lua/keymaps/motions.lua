vim.keymap.set('n', 'qb', '<cmd>normal sfb<CR>', { desc = 'Surrounding bracket', silent = true })
vim.keymap.set('n', 'qv', '<cmd>normal sfnb<CR>', { desc = 'Next surrounding bracket', silent = true })
vim.keymap.set('n', 'qo', '<cmd>normal vxov<CR>', { desc = 'Cursor to root TS node', silent = true })
vim.keymap.set('n', 'qk', '$', { desc = 'End of line', silent = true })
vim.keymap.set('n', '<c-e>', '$', { desc = 'End of line', silent = true })
vim.keymap.set('v', '<c-e>', '$', { desc = 'End of line', silent = true })
vim.keymap.set('n', '<c-a>', '0', { desc = 'End of line', silent = true })
vim.keymap.set('v', '<c-a>', '0', { desc = 'Start of line', silent = true })

-- TODO: Give <c-h> something useful
vim.keymap.set('n', '<c-h>', '$', { desc = 'End of line', silent = true })
vim.keymap.set('n', 'qi', '>>', { desc = 'Indent', silent = true })
vim.keymap.set('n', 'qg', 'G', { desc = 'Go to end of file', silent = true })
vim.keymap.set('n', 'gl', '$', { desc = 'Go to end of line', silent = true })
vim.keymap.set('n', 'ge', 'G', { desc = 'Go to end of file', silent = true })
vim.keymap.set('v', 'ge', 'G', { desc = 'Go to end of file', silent = true })
vim.keymap.set('n', 'gp', 'G', { desc = 'Go to end of file', silent = true })
vim.keymap.set('n', 'qp', 'yyp', { desc = 'Yank and paste current line', silent = true })
vim.keymap.set('n', '<c-p>', 'yyp', { desc = 'Yank and paste current line', silent = true })
vim.keymap.set('v', 'q', '$h', { desc = 'End of line', silent = true })

-- Easy duplication of lines
vim.keymap.set('x', '<c-p>', function()
  local cmd = ''
  if vim.fn.mode() == 'V' then
    cmd = "y'>vo<esc>pO<esc>j"
  else
    cmd = "y']o<esc>pO<esc>j"
  end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, true, true), 'n', true)
end, { noremap = true })

vim.keymap.set('n', 'qd', 'dd', { desc = 'Delete line', silent = true })
vim.keymap.set('n', 'dq', 'dd', { desc = 'Delete line', silent = true })
vim.keymap.set('n', 'qy', 'yy', { desc = 'Yank Line', silent = true })
vim.keymap.set('n', 'qm', 'v$', { desc = 'Visual Select Until $', silent = true })

-- Navigate through recent changes like g; and g,
-- with C-; and C-,

vim.keymap.set('n', '<C-;>', 'g;', { desc = 'Previous change', silent = true })
vim.keymap.set('n', '<C-,>', 'g,', { desc = 'Next change', silent = true })
