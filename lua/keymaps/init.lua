require 'keymaps.terminal'
require 'keymaps.navigation'
require 'keymaps.splits'
require 'keymaps.clipboard'
require 'keymaps.lua_tools'
require 'keymaps.cwd'
require 'keymaps.commands'
require 'keymaps.git'
require 'keymaps.helix'
require 'keymaps.fzf'
require 'keymaps.kitty'
require 'keymaps.yazi'
require 'keymaps.insert'
require 'keymaps.buffer_ops'
require 'keymaps.motions'
require 'keymaps.comments'
require 'keymaps.cpp'


-- [t and ]t to navigate between buffers
vim.keymap.set('n', '<a-q>', ':q!<cr>', { desc = 'Close nvim', silent = true })
