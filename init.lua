require 'opts'
require 'keymaps'
require 'autocmds'
require 'usercmds'
require 'neovide'
require 'lsp'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

local config_dir = vim.fn.stdpath 'config'
local lockfile_path = config_dir .. '/lazy-lock.json'
-- If config is read-only (common with NixOS symlinked configs), write lockfile elsewhere.
if vim.fn.filewritable(config_dir) ~= 2 then
  lockfile_path = vim.fn.stdpath 'state' .. '/lazy-lock.json'
end

require('lazy').setup({
  spec = {
    { import = "plugins" },
  },
  defaults = {
    lazy = true,
  },
  lockfile = lockfile_path,
  change_detection = {
    enabled = true,
    notify = false,
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true, -- reset the package path to improve startup time
    rtp = {
      reset = true,        -- reset the runtime path to $VIMRUNTIME and your config directory
      paths = {},          -- add any custom paths here that you want to includes in the rtp
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        -- 'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
        'editorconfig',
        'man',
        'osc52',
        'rplugin',
        'shada',
        'spellfile',
      },
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
