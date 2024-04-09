-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.guicursor = ''
-- Don't give ATTENTION when existing swap file found
vim.o.shortmess = vim.o.shortmess .. 'A'
-- vim.opt.guicursor = "n-v-c-i:block"
-- -- https://www.reddit.com/r/neovim/comments/12cc7gq/startup_screen_disappears_immediately_after_using/
vim.opt.shortmess:append { I = true }

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Set tabstop and shiftwidth as 4
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, for help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 200

-- Neovide settings
if vim.g.neovide then
  -- vim.api.nvim_set_keymap('n', '<D-v>', '"*p', { noremap = true })
  vim.o.guifont = 'MesloLGS NF:h13'
  -- Set current working directory to the project directory env var
  local projects_dir = os.getenv 'PROJECTS_DIR'
  vim.cmd('cd ' .. projects_dir)
  -- vim.api.nvim_set_keymap('i', '<D-v>', '<cmd><ESC> "*P<cr>', { noremap = true })
  vim.keymap.set('i', '<D-v>', '<C-r>*') -- Paste insert mode
  vim.keymap.set('t', '<D-v>', '<C-\\><C-n>l"+Pli') -- Paste insert mode
  vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
  vim.keymap.set('v', '<D-v>', '"+P') -- Paste visual mode
  vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
  vim.g.neovide_input_macos_alt_is_meta = true
  vim.o.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20'
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

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })

-- [t and ]t to navigate between buffers
vim.keymap.set('n', '[b', ':bprev<CR>', { desc = 'Go to previous [B]uffer' })
vim.keymap.set('n', ']b', ':bnext<CR>', { desc = 'Go to next [B]uffer' })
-- [t and ]t to navigate between tabs
vim.keymap.set('n', '[t', ':tabprev<CR>', { desc = 'Go to previous [T]ab' })
vim.keymap.set('n', ']t', ':tabnext<CR>', { desc = 'Go to next [T]ab' })
-- gh to do the same as gt -- switch tabs
vim.keymap.set('n', 'gy', ':tabnext<CR>', { desc = 'Go to next [T]ab' })
vim.keymap.set('n', 'gh', ':tabprev<CR>', { desc = 'Go to previous [T]ab' })
-- Quick  ways to get to certain tabs

-- Iterate through modes: ['n', 'i', 't']
-- and set the keymapping in each mode
for _, mode in ipairs { 'n', 'i', 't' } do
  local cmd = ''
  if mode == 'i' then
    cmd = '<Esc>'
  elseif mode == 't' then
    cmd = '<C-\\><C-n>'
  end
  vim.keymap.set(mode, 'gko', cmd .. ':tabn 1<CR>', {})
  vim.keymap.set(mode, 'gkp', cmd .. ':tabn 2<CR>', {})
  vim.keymap.set(mode, 'gkl', cmd .. ':tabn 3<CR>', {})
  vim.keymap.set(mode, 'gkd', cmd .. ':tabn 4<CR>', {})
  vim.keymap.set(mode, 'gk;', cmd .. ':tabn 4<CR>', {})
  vim.keymap.set(mode, 'gke', cmd .. ':tabn 5<CR>', {})
  vim.keymap.set(mode, 'gkf', cmd .. ':tabn 6<CR>', {})
  vim.keymap.set(mode, 'gkg', cmd .. ':tabn 7<CR>', {})
  vim.keymap.set(mode, 'gkh', cmd .. ':tabn 8<CR>', {})
  vim.keymap.set(mode, 'gki', cmd .. ':tabn 9<CR>', {})
  vim.keymap.set(mode, 'gkj', cmd .. ':tabn 10<CR>', {})
  vim.keymap.set(mode, 'gkk', cmd .. ':tabn 11<CR>', {})
end

vim.keymap.set('n', '<leader>q', ':q<CR>', { silent = true })

-- For letter in a-z make a keymapping
-- gm<char> in normal mode to go to the upper case mark
-- <CHAR>

-- Iterate through the lowercase alphabet
for ch = 97, 122 do
  local char = string.char(ch)
  vim.keymap.set('n', 'gm' .. char, ':normal! `' .. char:upper() .. '<CR>', {})
end

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Open [D]iagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>gg', ':-tabnew | term lazygit<CR>i', { noremap = true })

local function openLazyGitFloating()
  local width = vim.api.nvim_get_option 'columns'
  local height = vim.api.nvim_get_option 'lines'

  local win_height = math.ceil(height * 0.8 - 4)
  local win_width = math.ceil(width * 0.8)
  local row = math.ceil((height - win_height) / 2 - 1)
  local col = math.ceil((width - win_width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = 'minimal',
  })

  vim.api.nvim_command 'term lazygit'
  vim.api.nvim_command 'startinsert'
end
vim.keymap.set('n', '<leader>gh', openLazyGitFloating, { noremap = true })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { silent = true })
vim.keymap.set('t', 'jk', '<C-\\><C-n>', { silent = true })
vim.keymap.set('t', 'ji', '<C-\\><C-n>', { silent = true })

-- Testing escape keys
local mapping = { 'ji', 'jk' }
for _, key in ipairs(mapping) do
  vim.keymap.set('i', key, '<Esc>', { silent = true })
end

vim.keymap.set('t', '90', '<C-r>', { silent = true })
vim.keymap.set('t', '89', '<C-t>', { silent = true })
vim.keymap.set('t', 'oio', '<C-r>', { silent = true })
vim.keymap.set('n', '90w', '<C-W><C-W>', { silent = true })
vim.keymap.set('n', '89', '<C-W><C-W>', { silent = true })
vim.keymap.set('n', 'gw', '<C-W><C-W>', { silent = true })
vim.keymap.set('i', '90w', '<C-W>', { silent = true })
vim.keymap.set('t', '90w', '<C-W>', { silent = true })
vim.keymap.set('i', 'fb', '<Esc><C-W><C-W>', { silent = true })
vim.keymap.set('t', 'fb', '<C-\\><C-n><C-W><C-W>', { silent = true })

vim.keymap.set('n', '90o', '<C-W><C-O>', { silent = true })
vim.keymap.set('i', '90o', '<C-W><C-O>', { silent = true })
vim.keymap.set('t', '90o', '<C-W><C-O>', { silent = true })
vim.keymap.set('n', '90q', '<C-W><C-O>', { silent = true })
vim.keymap.set('i', '90q', '<C-W><C-O>', { silent = true })
vim.keymap.set('t', '90q', '<C-W><C-O>', { silent = true })

vim.keymap.set('i', 'jfj', ';', { silent = true })
vim.keymap.set('i', 'jfd', '.', { silent = true })
vim.keymap.set('i', 'jfg', '>', { silent = true })
vim.keymap.set('i', 'jfq', '?', { silent = true })
vim.keymap.set('i', 'jfs', '/', { silent = true })

-- System clipboard
-- Function to copy yanked text to system clipboard
local function yank_to_clipboard()
  local yanked_text = vim.fn.getreg '"' -- Get the last yanked text
  vim.fn.setreg('+', yanked_text) -- Set the yanked text to the clipboard register
end

-- Command to call the Lua function
vim.api.nvim_create_user_command('Y', yank_to_clipboard, {})

vim.api.nvim_set_keymap('n', '<leader>y', 'gv"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>y', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-y>', '"+y', { noremap = true, silent = true })

-- Faster write
-- Only with function it doesn't come up as double write
vim.keymap.set('n', '<leader>w', function()
  vim.cmd 'w'
end, { silent = true })

-- Faster comment line
vim.api.nvim_set_keymap('n', 'co', 'gcc', { silent = true })

local changeDir = function()
  local file_path = vim.fn.expand '%:p'
  local dir_path = vim.fn.fnamemodify(file_path, ':h')
  vim.api.nvim_set_current_dir(dir_path)
end
vim.keymap.set('n', 'cd', changeDir, { desc = 'Change [C]urrent [D]irectory to parent of curfile' })

-- Useful keymaps
vim.keymap.set('n', '\\', ':split<CR>', { silent = true, desc = 'Vertical Split' })
vim.keymap.set('n', '|', ':vsplit<CR>', { silent = true, desc = 'Horizontal Split' })
vim.keymap.set('n', '<C-\\>', ':split | term<CR>', { silent = true, desc = 'Vertical Split' })
-- Not working yet
vim.keymap.set('n', '<C-|>', ':vsplit | term<CR>', { silent = true, desc = 'Horizontal Split' })

-- Custom key remapping
-- Function to run when entering insert mode
local function onInsertEnter()
  -- Set Caps Lock to Escape
  -- vim.fn.jobstart('karabiner_cli --select-profile viminsert', { detach = true })
end

-- Function to run when leaving insert mode
local function onInsertLeave()
  -- Set caps lock to control
  -- vim.fn.jobstart('karabiner_cli --select-profile default', { detach = true })
end

-- Set up autocommands
vim.api.nvim_create_autocmd('InsertEnter', {
  pattern = '*',
  callback = onInsertEnter,
})

vim.api.nvim_create_autocmd('InsertLeave', {
  pattern = '*',
  callback = onInsertLeave,
})

vim.api.nvim_create_autocmd('TermClose', {
  pattern = 'term://*',
  command = "lua vim.api.nvim_input('<CR>')",
})

-- Only load treesitter after the first buffer is loaded
-- to try and avoid some delays
-- vim.api.nvim_create_autocmd('BufReadPost', {
--   pattern = '*',
--   once = true,
--   callback = function()
--     -- TODO: Fix the pattern and only run once
--     vim.defer_fn(function()
--       vim.cmd 'Lazy load nvim-treesitter nvim-lspconfig'
--       vim.cmd 'LspStart'
--     end, 100)
--   end,
-- })

vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*.frag,*.vert,*.tesc,*.tese,*.geom,*.comp',
  command = 'set filetype=glsl',
})
vim.api.nvim_set_keymap('v', '<leader><leader>r', ':lua ExecuteVisualSelectionAsLua()<CR>', { noremap = true, desc = 'Execute lua' })
vim.api.nvim_set_keymap('n', '<leader><leader>s', ':source %<CR>', { noremap = true, desc = '[S]ource Lua File' })
vim.api.nvim_set_keymap('n', '<leader><leader>c', ':split | term zsh -l -c "cb; rn;"<CR>', { noremap = true, desc = '[c]make build and run ' })
vim.api.nvim_set_keymap('n', '<leader><leader>v', ':vsplit | term zsh -l -c "cb; rn;"<CR>', { noremap = true, desc = '[c]make build and run vertical ' })

-- Keymapping to run code inside of a visual selection
-- using :lua (visually selected code)
function ExecuteVisualSelectionAsLua()
  -- Save the original cursor position
  local save_cursor = vim.api.nvim_win_get_cursor(0)
  -- Get the current visual selection boundaries
  local _, start_line, _, _ = unpack(vim.fn.getpos "'<")
  local _, end_line, _, _ = unpack(vim.fn.getpos "'>")
  -- Adjust the line numbers for correct indexing
  start_line = start_line - 1
  end_line = end_line
  -- Capture the text within the visual selection
  local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
  local code_to_execute = table.concat(lines, '\n')
  -- Execute the captured Lua code
  local func = load(code_to_execute)
  if func then
    pcall(func)
  else
    print 'Error in the selected Lua code.'
  end
  -- Restore the cursor position
  vim.api.nvim_win_set_cursor(0, save_cursor)
end
local function terminal()
  vim.cmd 'term'
  vim.cmd 'startinsert'
end
local function terminalNewTab()
  vim.cmd 'tabnew | term'
  vim.cmd 'startinsert'
end
local function terminalVertical()
  vim.cmd 'vsplit | term'
  vim.cmd 'startinsert'
end
local function terminalHorizontal()
  vim.cmd 'split | term'
  vim.cmd 'startinsert'
end
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = 'New Tab' })
vim.keymap.set('n', '<leader>te', terminal, { desc = ':term' })
vim.keymap.set('n', '<leader>tk', terminal, { desc = ':term' })
vim.keymap.set('n', '<leader>tt', terminalNewTab, { desc = 'Terminal - New Tab' })
vim.keymap.set('n', '<leader>tv', terminalVertical, { desc = 'Terminal - Vertical' })
vim.keymap.set('n', '<leader>tj', terminalVertical, { desc = 'Terminal - Vertical' })
vim.keymap.set('n', '<leader>th', terminalHorizontal, { desc = 'Terminal - Horizontal' })
vim.keymap.set('n', '<leader>tr', ':tabclose<CR>', { desc = 'Tab Remove' })
vim.keymap.set('n', '<leader>tl', ':tablast<CR>', { desc = 'Tab Last' })
vim.keymap.set('n', '<leader>tf', ':tabfirst<CR>', { desc = 'Tab First' })
vim.keymap.set('n', '<leader>to', ':tabonly <CR>', { desc = 'Tab Only' })
vim.keymap.set('n', '<leader>tb', '<C-W>T', { desc = 'Move window into tab' })
local changeDirWindow = function()
  local file_path = vim.fn.expand '%:p'
  local dir_path = vim.fn.fnamemodify(file_path, ':h')
  vim.cmd('lcd ' .. dir_path)
end
local changeDirTab = function()
  local file_path = vim.fn.expand '%:p'
  local dir_path = vim.fn.fnamemodify(file_path, ':h')
  vim.cmd('tcd ' .. dir_path)
end
vim.keymap.set('n', '<leader>tc', changeDirTab, { desc = '[T]ab Change [C]urrent Directory to parent of curfile' })
vim.keymap.set('n', '<t', ':tabmove-1<CR>', { desc = 'Move tab to the left' })
vim.keymap.set('n', '>t', ':tabmove+1<CR>', { desc = 'Move tab to the right' })
vim.keymap.set('n', '<R', ':tabmove-1<CR>', { desc = 'Move tab to the left' })
vim.keymap.set('n', '>R', ':tabmove+1<CR>', { desc = 'Move tab to the right' })
vim.keymap.set('n', '<T', ':tabmove 0<CR>', { desc = 'Move tab to the far left' })
vim.keymap.set('n', '>T', ':tabmove $<CR>', { desc = 'Move tab to the far right' })

vim.keymap.set('n', '<leader>lc', changeDirWindow, { desc = 'Window Change [C]urrent Directory to parent of curfile' })
vim.api.nvim_create_user_command('T', ':-tabnew', {})
vim.api.nvim_create_user_command('TC', ':tabclose', {})
vim.api.nvim_create_user_command('TT', terminalNewTab, {})
vim.api.nvim_create_user_command('TV', terminalVertical, {})
vim.api.nvim_create_user_command('TH', terminalHorizontal, {})
-- Custom command to start a new terminal with tmux attach
vim.api.nvim_create_user_command('TA', function()
  vim.cmd 'new | term tmux a'
end, {})
vim.api.nvim_create_user_command('WQ', function()
  vim.cmd 'wq!'
end, {})
vim.api.nvim_create_user_command('Q', function()
  vim.cmd 'qall!'
end, {})

vim.api.nvim_create_user_command('B', ':b#', {})
vim.keymap.set('n', '<leader>bd', ':bd!<CR>', { desc = '[B]uffer [D]elete', silent = true })
vim.keymap.set('n', 'sb', ':b#<CR>', { desc = '[S]wap [B]uffer', silent = true })
vim.keymap.set('n', 'sj', ':b#<CR>', { desc = '[S]wap [B]uffer', silent = true })
vim.keymap.set('n', 'sk', ':tabnext#<CR>', { desc = '[S]wap Tab - Next', silent = true })
vim.keymap.set('n', 'st', ':tabnext<CR>', { desc = '[S]wap [T]ab', silent = true })
vim.keymap.set('n', 'qj', '<C-W><C-W>', { desc = 'Swap Window', silent = true })
vim.keymap.set('n', 'sn', '<C-W><C-W>', { desc = 'Swap Window', noremap = true, silent = true })
vim.keymap.set('n', 'qk', '$', { desc = 'End of line', silent = true })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins, you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup {
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  { 'tpope/vim-sleuth', lazy = false }, -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --
  --  This is equivalent to:
  --    require('Comment').setup({})

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {}, event = 'BufReadPost' },

  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`. This is equivalent to the following lua:
  --    require('gitsigns').setup({ ... })
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPost',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    keys = { '<leader>', 'a', 'b', 'c', 'g', 'h', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', ']', '[' },
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup {
        triggers_blacklist = {
          -- list of mode / prefixes that should never be hooked by WhichKey
          -- this is mostly relevant for keymaps that start with a native binding
          i = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'f', 'i', '9', '8', 'w', 'd' },
          v = { 'j', 'k' },
        },
      }

      -- Document existing key chains
      require('which-key').register {
        ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
        ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
        ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
        ['<leader>f'] = { name = '[F]ind', _ = 'which_key_ignore' },
        ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
      }
    end,
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin,

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    cmd = { 'Mason' },
    lazy = false,
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },
      { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
      -- Brief Aside: **What is LSP?**
      --
      -- LSP is an acronym you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself
          -- many times.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-T>.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>sd', require('telescope.builtin').lsp_document_symbols, '[S]ymbols: [D]ocument ')
          map('<leader>dn', require('telescope.builtin').lsp_document_symbols, '[S]ymbols: [D]ocument ')

          -- Fuzzy find all the symbols in your current workspace
          --  Similar to document symbols, except searches over your whole project.
          map('<leader>ss', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[S]ymbols: [W]orkspace')

          -- Rename the variable under your cursor
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          -- map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP Specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.offsetEncoding = 'utf-8'
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        clangd = {},
        -- gopls = {},
        pyright = {},
        -- glslls = {
        --   filetypes = { 'glsl', 'vert', 'frag', 'geom', 'comp' },
        -- },
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`tsserver`) will work just fine
        -- tsserver = {},
        --

        lua_ls = {
          -- cmd = {...},
          -- filetypes { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu
      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format lua code
        'clangd',
        -- 'glslls',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    lazy = false,
    opts = {
      notify_on_error = false,
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        -- javascript = { { "prettierd", "prettier" } },
      },
    },
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    -- event = { 'InsertEnter', 'CmdlineEnter' },
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets
          -- This step is not supported in many windows environments
          -- Remove the below condition to re-enable on windows
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },

      'onsails/lspkind.nvim',
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',

      -- If you want to add a bunch of pre-configured snippets,
      --    you can use this plugin to help you. It even has snippets
      --    for various frameworks/libraries/etc. but you will have to
      --    set up the ones that are useful for you.
      'rafamadriz/friendly-snippets',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local lspkind = require 'lspkind'
      luasnip.config.setup {}
      require('luasnip.loaders.from_vscode').lazy_load { paths = { './snippets' } }

      local completeOrJump = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.confirm { select = true }
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      -- cmp.setup.cmdline(':', {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = cmp.config.sources({
      --     { name = 'cmdline', keyword_length = 5 },
      --   }, {
      --     { name = 'path', keyword_length = 5 },
      --   }),
      -- })
      -- could reenable this if i can disable tab and only tab native
      -- or find way eg. start typing ne and it has good completion

      -- cmp.setup.cmdline('/', {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = {
      --     { name = 'buffer' },
      --   },
      -- })

      cmp.setup {
        formatting = {
          fields = { 'abbr', 'kind', 'menu' },
          expandable_indicator = true,
          format = lspkind.cmp_format {
            mode = 'symbol', -- show only symbol annotations
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            -- can also be a function to dynamically calculate max width such as
            -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            show_labelDetails = true, -- show labelDetails in menu. Disabled by default

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            -- before = function (entry, vim_item)
            --   return vim_item
            -- end
            with_text = true,
            menu = {
              nvim_lsp = '[LSP]',
              luasnip = '[LuaSnip]',
              path = '[Path]',
              cody = '[cody]',
            },
          },
        },

        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<C-m>'] = cmp.mapping.select_next_item(),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<CR>'] = completeOrJump,
          ['<C-j>'] = completeOrJump,
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          -- { name = 'cody' },
        },
      }
    end,
  },

  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`
    'folke/tokyonight.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- Load the colorscheme here
      vim.cmd.colorscheme 'tokyonight-night'

      -- You can configure highlights by doing something like
      vim.cmd.hi 'Comment gui=none'
    end,
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'BufReadPost', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    event = 'BufReadPost',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup {
        n_lines = 100,
        mappings = {
          update_n_lines = '',
        },
      }

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      -- local statusline = require 'mini.statusline'
      -- statusline.setup()

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      -- ---@diagnostic disable-next-line: duplicate-set-field
      -- statusline.section_location = function()
      --   return '%2l:%-2v'
      -- end
      --
      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
  -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- put them in the right spots if you want.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for kickstart
  --
  --  Here are some example plugins that I've included in the kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  { import = 'custom.plugins' },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
