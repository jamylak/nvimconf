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
