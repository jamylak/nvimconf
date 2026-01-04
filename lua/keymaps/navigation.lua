local utils = require 'utils'

-- Window Navigation
vim.keymap.set('n', '<a-d>', '<C-W><C-W>', { desc = 'Go to next Window', silent = true })
vim.keymap.set('n', 'm', '<C-W><C-W>', { desc = 'Go to prev Window', silent = true })
vim.keymap.set('n', 'M', '<C-W>W', { desc = 'Go to previously active Window', silent = true })
vim.keymap.set('n', 'gw', '<C-W><C-W>', { silent = true })
vim.keymap.set('n', 'qw', '<C-W><C-O>', { silent = true })

-- Buffer Navigation
vim.api.nvim_create_user_command('B', ':b#', {})
vim.keymap.set('n', '<leader>bd', ':bd!<CR>', { desc = '[B]uffer [D]elete', silent = true })
vim.keymap.set('n', 'sb', ':b#<CR>', { desc = '[S]wap [B]uffer', silent = true })
vim.keymap.set('n', 'sj', ':b#<CR>', { desc = '[S]wap [B]uffer', silent = true })
vim.keymap.set('n', 'sk', ':tabnext#<CR>', { desc = '[S]wap Tab - Next', silent = true })
vim.keymap.set('n', 'qj', '<C-W>p', { desc = 'Swap Window', silent = true })
vim.keymap.set('n', '[b', '<cmd>bprev<CR>', { desc = 'Go to previous [B]uffer' })
vim.keymap.set('n', ']b', '<cmd>bnext<CR>', { desc = 'Go to next [B]uffer' })
vim.keymap.set('n', 'L', ':b#<CR>', { desc = 'Go to last active buffer', silent = true })

-- TAB Navigation
vim.keymap.set('n', '[t', '<cmd>tabprev<CR>', { desc = 'Go to previous [T]ab' })
vim.keymap.set('n', ']t', '<cmd>tabnext<CR>', { desc = 'Go to next [T]ab' })
vim.keymap.set('n', '<a-[>', '<cmd>tabprev<CR>', { desc = 'Go to previous [T]ab' })
vim.keymap.set('n', '<a-]>', '<cmd>tabnext<CR>', { desc = 'Go to next [T]ab' })
vim.keymap.set('i', '<a-[>', '<esc><cmd>tabprev<CR>', { desc = 'Go to previous [T]ab' })
vim.keymap.set('i', '<a-]>', '<esc><cmd>tabnext<CR>', { desc = 'Go to next [T]ab' })
-- gh to do the same as gt -- switch tabs
vim.keymap.set('n', 'gy', ':tabnext<CR>', { desc = 'Go to next [T]ab' })
vim.keymap.set('n', 'gh', ':tabprev<CR>', { desc = 'Go to previous [T]ab' })
-- Quick  ways to get to certain tabs

-- Iterate through modes: ['n', 'i', 't']
-- and set the keymapping in each mode
-- TODO: Test HU, HI etc
for _, mode in ipairs { 'n', 'i', 't' } do
  local cmd = ''
  if mode == 'i' then
    cmd = '<Esc>'
  elseif mode == 't' then
    cmd = '<C-\\><C-n>'
  end
  vim.keymap.set(mode, 'gko', cmd .. ':tabn 1<CR>', {})
  -- TODO: Make enter the 2nd?
  vim.keymap.set(mode, 'gk<cr>', cmd .. ':tabn 2<CR>', {})
  vim.keymap.set(mode, 'gk ', cmd .. ':tabn 3<CR>', {})
  vim.keymap.set(mode, 'gkg', cmd .. ':tabn 4<CR>', {})
  -- TODO: adjust these?
  vim.keymap.set(mode, 'gkk', cmd .. ':tabn 5<CR>', {})
  vim.keymap.set(mode, 'gkd', cmd .. ':tabn 6<CR>', {})
  vim.keymap.set(mode, 'gke', cmd .. ':tabn 7<CR>', {})
end

for i = 1, 8 do
  vim.keymap.set('n', '<a-' .. i .. '>', ':tabn ' .. i .. '<CR>', { desc = 'Go to tab ' .. i })
  vim.keymap.set('n', '<leader>t' .. i, ':tabn ' .. i .. '<CR>', { desc = 'Go to tab ' .. i })
end
-- 9 = last tab
vim.keymap.set('n', '<a-0>', ':tabn 1<cr>', { desc = 'Go to last tab' })
vim.keymap.set('n', '<a-9>', ':tabn $<cr>', { desc = 'Go to last tab' })
vim.keymap.set('n', '<a-s-[>', ':tabprev<cr>', { desc = 'Go to previous tab', silent = true })
vim.keymap.set('n', '<a-s-]>', ':tabnext<cr>', { desc = 'Go to next tab', silent = true })
vim.keymap.set('n', '<a-s-x>', ':tabclose<cr>', { desc = 'Close tab', silent = true })
vim.keymap.set('n', '<a-s-w>', ':tabclose<cr>', { desc = 'Close tab', silent = true })
vim.keymap.set('n', '<a-w>', utils.CloseTabOrQuit, { desc = 'Close tab', silent = true })

vim.keymap.set('n', '<leader>tr', ':tabclose<CR>', { desc = 'Tab Remove' })
vim.keymap.set('n', '<leader>tl', ':tablast<CR>', { desc = 'Tab Last' })
vim.keymap.set('n', '<leader>tf', ':tabfirst<CR>', { desc = 'Tab First' })
vim.keymap.set('n', '<leader>to', ':tabonly <CR>', { desc = 'Tab Only' })
vim.keymap.set('n', '<leader>tb', '<C-W>T', { desc = 'Move window into tab' })
vim.keymap.set('n', '<t', ':tabmove-1<CR>', { desc = 'Move tab to the left' })
vim.keymap.set('n', '>t', ':tabmove+1<CR>', { desc = 'Move tab to the right' })
vim.keymap.set('n', '<R', ':tabmove-1<CR>', { desc = 'Move tab to the left' })
vim.keymap.set('n', '>R', ':tabmove+1<CR>', { desc = 'Move tab to the right' })
vim.keymap.set('n', '<T', ':tabmove 0<CR>', { desc = 'Move tab to the far left' })
vim.keymap.set('n', '>T', ':tabmove $<CR>', { desc = 'Move tab to the far right' })

vim.api.nvim_create_user_command('T', ':-tabnew', {})
vim.api.nvim_create_user_command('TC', ':tabclose', {})

vim.keymap.set('n', '<a-q>', ':q!<cr>', { desc = 'Close nvim', silent = true })
