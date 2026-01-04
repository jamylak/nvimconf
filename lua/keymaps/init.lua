local utils = require 'utils'
require 'keymaps.terminal'
require 'keymaps.navigation'
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
require 'keymaps.cpp'


-- TODO: Keymap for [TAB] in normal mode?
-- TODO: Maybe reconsider [ENTER] in normal mode?


-- [t and ]t to navigate between buffers
vim.keymap.set('n', '<a-q>', ':q!<cr>', { desc = 'Close nvim', silent = true })


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
