-- Neovide settings
if vim.g.neovide then
  -- vim.api.nvim_set_keymap('n', '<D-v>', '"*p', { noremap = true })
  vim.o.guifont = 'Fira Code Medium:h18'
  -- Set current working directory to the project directory env var
  local projects_dir = os.getenv 'PROJECTS_DIR'
  vim.cmd('cd ' .. projects_dir)
  -- vim.api.nvim_set_keymap('i', '<D-v>', '<cmd><ESC> "*P<cr>', { noremap = true })
  vim.keymap.set('i', '<D-v>', '<C-r>*') -- Paste insert mode
  vim.keymap.set('t', '<D-v>', '<C-\\><C-n>l"+Pli') -- Paste insert mode
  vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
  vim.keymap.set('v', '<D-v>', '"+P') -- Paste visual mode
  vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
  vim.g.neovide_input_macos_option_key_is_meta = 'both'
  vim.o.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20'
  -- Set ENV var SHELL to fish
  vim.o.shell = '/opt/homebrew/bin/fish'

  -- For mode in Normal, Terminal, and Visual
  for _, mode in ipairs { 'i', 'n', 't', 'v' } do
    -- If we are in terminal mode, cmdPrefix is <C-\><C-n>
    -- If we are in normal mode, cmdPrefix is empty
    -- If we are in insert mode cmdPrefix is <ESC>
    local cmd = ''
    if mode == 't' then
      cmd = '<C-\\><C-n>'
    elseif mode == 'i' then
      cmd = '<ESC>'
    end
    -- Set D-0 to D-9 to switch to the corresponding tab
    for i = 0, 9 do
      vim.api.nvim_set_keymap(mode, '<D-' .. i .. '>', cmd .. ':' .. i .. 'tabnext<CR>', { noremap = true, silent = true })
    end

    -- Set D-Shift-[ to D-Shift-] to switch to the previous/next tab
    vim.api.nvim_set_keymap(mode, '<D-{>', cmd .. ':tabprevious<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap(mode, '<D-}>', cmd .. ':tabnext<CR>', { noremap = true, silent = true })

    vim.api.nvim_set_keymap(mode, '<D-]>', '<C-w>w', { silent = true })
    vim.api.nvim_set_keymap(mode, '<D-[>', '<C-w>W', { silent = true })

    local utils = require 'utils'
    -- Set D-T to open a new tab
    vim.keymap.set(mode, '<D-t>', utils.terminalNewTab, { noremap = true, silent = true })
    vim.keymap.set(mode, '<D-\\>', utils.terminalVSplit, { noremap = true, silent = true })
    vim.keymap.set(mode, '<D-CR>', utils.terminalHSplit, { noremap = true, silent = true })
    -- Set D-W to close the current tab
    vim.api.nvim_set_keymap(mode, '<D-w>', cmd .. ':tabclose<CR>', { noremap = true, silent = true })
    -- Set D-Shift-W to close all tabs except the current one
    vim.api.nvim_set_keymap(mode, '<D-W>', cmd .. ':tabonly<CR>', { noremap = true, silent = true })
    -- Set D-O to close other windows except current
    vim.api.nvim_set_keymap(mode, '<D-o>', cmd .. ':only<CR>', { noremap = true, silent = true })
    -- Set D-F to run keybinding 'su' which is find on recent files
    vim.api.nvim_set_keymap(mode, '<D-f>', 'su', { silent = true })

    vim.g.neovide_scale_factor = 1.0
    local change_scale_factor = function(delta)
      vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
    end
    vim.keymap.set(mode, '<D-=>', function()
      change_scale_factor(1.25)
    end, { silent = true })
    vim.keymap.set(mode, '<D-->', function()
      change_scale_factor(1 / 1.25)
    end, { silent = true })
  end

  -- Open telescope old files
  vim.defer_fn(function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local utils = require 'utils'
    if bufname == '' then
      -- It's the empty buffer, so we didn't open neovide
      -- with a file, so show old files selector
      vim.cmd 'Telescope oldfiles'
    elseif string.find(bufname, 'oil') then
      utils.cd_to_git_root()
      vim.cmd 'Telescope find_files'
    else
      -- Should be a regular file, so cd to git root
      utils.cd_to_git_root()
    end
  end, 200)
end

vim.g.neovide_scroll_animation_length = 0.05
vim.g.neovide_transparency = 0.7
vim.g.neovide_window_blurred = true
vim.g.neovide_show_border = true -- Doesn't seem to do anything
vim.g.neovide_hide_mouse_when_typing = true
-- vim.g.neovide_cursor_animation_length = 0.05
vim.g.neovide_cursor_antialiasing = true
vim.g.neovide_cursor_animate_command_line = true
vim.g.neovide_cursor_unfocused_outline_width = 0.18

-- Railgun
-- vim.g.neovide_cursor_vfx_mode = 'railgun'
-- vim.g.neovide_cursor_vfx_opacity = 700.0
-- vim.g.neovide_cursor_vfx_particle_lifetime = 0.7
-- vim.g.neovide_cursor_vfx_particle_density = 43.0
-- vim.g.neovide_cursor_vfx_particle_speed = 13.0
-- vim.g.neovide_cursor_vfx_particle_phase = 30.5
-- vim.g.neovide_cursor_vfx_particle_curl = 0.3

-- Pixiedust
vim.g.neovide_cursor_vfx_mode = 'pixiedust'
vim.g.neovide_cursor_vfx_opacity = 1000.0
vim.g.neovide_cursor_vfx_particle_lifetime = 0.7
vim.g.neovide_cursor_vfx_particle_density = 125.0
vim.g.neovide_cursor_vfx_particle_speed = 10.0
