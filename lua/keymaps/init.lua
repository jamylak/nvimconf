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
require 'keymaps.buffer_ops'
require 'keymaps.motions'
require 'keymaps.git_root'
require 'keymaps.comments'

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

