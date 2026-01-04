local utils = require 'utils'
require 'keymaps.terminal'
require 'keymaps.tabs'
require 'keymaps.splits'
require 'keymaps.clipboard'
require 'keymaps.lua_tools'
require 'keymaps.cwd'
require 'keymaps.commands'
require 'keymaps.git_url'
require 'keymaps.helix'
require 'keymaps.fzf'
require 'keymaps.kitty'
require 'keymaps.yazi'
require 'keymaps.insert'

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Keymap to do search with <c-s> eg. same as / but with <c-s>
-- vim.keymap.set('n', '<C-s>', '/', { silent = true })
vim.keymap.set('n', '<C-s>', function()
  vim.fn.feedkeys(vim.api.nvim_replace_termcodes('/', true, true, true), 'n')
end, { silent = true, noremap = true })

-- TODO: Keymap for [TAB] in normal mode?
-- TODO: Maybe reconsider [ENTER] in normal mode?

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
-- Next quickfix eg. like :cn or :cp but for ]q and [q
vim.keymap.set('n', ']q', '<cmd>cnext<CR>', { desc = 'Go to next [Q]uickfix' })
vim.keymap.set('n', '[q', '<cmd>cprev<CR>', { desc = 'Go to previous [Q]uickfix' })

-- [t and ]t to navigate between buffers
vim.keymap.set('n', '[b', '<cmd>bprev<CR>', { desc = 'Go to previous [B]uffer' })
vim.keymap.set('n', ']b', '<cmd>bnext<CR>', { desc = 'Go to next [B]uffer' })
vim.keymap.set('n', '<a-d>', '<C-W><C-W>', { desc = 'Go to next Window', silent = true })
vim.keymap.set('n', 'm', '<C-W><C-W>', { desc = 'Go to prev Window', silent = true })
vim.keymap.set('n', 'L', ':b#<CR>', { desc = 'Go to last active buffer', silent = true })
vim.keymap.set('n', 'M', '<C-W>W', { desc = 'Go to previously active Window', silent = true })
vim.keymap.set('n', '<a-q>', ':q!<cr>', { desc = 'Close nvim', silent = true })


-- For letter in a-z make a keymapping
-- gm<char> in normal mode to go to the upper case mark
-- <CHAR>

-- Iterate through the lowercase alphabet
for ch = 97, 122 do
  local char = string.char(ch)
  vim.keymap.set('n', 'gm' .. char, ':normal! `' .. char:upper() .. '<CR>', {})
end

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader><c-q>', vim.diagnostic.setloclist, { desc = 'Open Diagnostic [Q]uickfix list' })


-- Testing escape keys
local mapping = { 'ji', 'jk' }
for _, key in ipairs(mapping) do
  vim.keymap.set('i', key, '<Esc>', { silent = true })
end

vim.keymap.set('n', 'gw', '<C-W><C-W>', { silent = true })
vim.keymap.set('i', '90w', '<C-W>', { silent = true })
vim.keymap.set('i', 'JF', ';', { silent = true })
vim.keymap.set('i', 'jfe', ';', { silent = true })
vim.keymap.set('i', 'jgr', ';', { silent = true })
vim.keymap.set('i', '902', '>', { silent = true })
vim.keymap.set('i', '903', '->', { silent = true })
vim.keymap.set('i', '904', ');', { silent = true })
vim.keymap.set('t', '90w', '<C-W>', { silent = true })
vim.keymap.set('n', 'qw', '<C-W><C-O>', { silent = true })

vim.keymap.set('i', 'jfj', ';', { silent = true })
vim.keymap.set('i', 'jfd', '.', { silent = true })
vim.keymap.set('i', 'jfg', '>', { silent = true })
vim.keymap.set('i', 'jfq', '?', { silent = true })
vim.keymap.set('i', 'jfs', '/', { silent = true })

-- Faster write
-- Only with function it doesn't come up as double write
vim.keymap.set('n', '<leader>w', function()
  vim.cmd 'w'
end, { silent = true })

-- Faster comment line
vim.api.nvim_set_keymap('n', 'co', 'gcc', { silent = true })
vim.api.nvim_set_keymap('n', '<C-c>', 'gcc', { silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>c', 'gcc', { silent = true })
vim.api.nvim_set_keymap('v', '<leader>c', 'gc', { silent = true })
vim.api.nvim_set_keymap('v', '<C-c>', 'gc', { silent = true })





vim.api.nvim_create_user_command('B', ':b#', {})
vim.keymap.set('n', '<leader>bd', ':bd!<CR>', { desc = '[B]uffer [D]elete', silent = true })
vim.keymap.set('n', 'sb', ':b#<CR>', { desc = '[S]wap [B]uffer', silent = true })
vim.keymap.set('n', 'sj', ':b#<CR>', { desc = '[S]wap [B]uffer', silent = true })
vim.keymap.set('n', 'sk', ':tabnext#<CR>', { desc = '[S]wap Tab - Next', silent = true })
vim.keymap.set('n', 'qj', '<C-W>p', { desc = 'Swap Window', silent = true })
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

-- Switch from header file to source file and vice versa
-- This is useful when you are working with C/C++ projects
-- For example if i'm in include/abc.h it will go to src/abc.cpp
-- If i'm in src/abc.cpp it will go to include/abc.h
vim.api.nvim_create_user_command('S', function()
  local file_path = vim.fn.expand '%:p:h'
  local file_name = vim.fn.expand '%:t'
  local new_file_path = ''
  local new_file_name = ''
  if file_path:match 'include' then
    new_file_path = file_path:gsub('include', 'src')
  elseif file_path:match 'src' then
    new_file_path = file_path:gsub('src', 'include')
  else
    new_file_path = file_path
  end
  if file_name:match '%.cpp' then
    new_file_name = file_name:gsub('%.cpp', '.h')
  elseif file_name:match '%.h' then
    new_file_name = file_name:gsub('%.h', '.cpp')
  end
  new_file_path = new_file_path .. '/' .. new_file_name
  vim.cmd('e ' .. new_file_path)
end, {})

-- [+Space and ]+Space to insert newline above or below cursor
vim.keymap.set('n', '[<Space>', 'O<Esc>j', { desc = 'Insert newline above cursor', silent = true })
vim.keymap.set('n', ']<Space>', 'o<Esc>k', { desc = 'Insert newline below cursor', silent = true })

vim.keymap.set('n', '<leader>v', utils.tcd_to_git_root, { noremap = true })
vim.keymap.set('n', '<leader>V', utils.cd_to_git_root, { noremap = true })
vim.keymap.set('n', '<m-v>', utils.cd_to_git_root, { noremap = true })
vim.keymap.set('n', '<leader>bc', utils.cd_to_git_root, { noremap = true })

-- user command to cd_to_git_root
vim.api.nvim_create_user_command('CD', function()
  utils.cd_to_git_root()
end, {})

vim.api.nvim_create_user_command('TCD', function()
  utils.tcd_to_git_root()
end, {})

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

