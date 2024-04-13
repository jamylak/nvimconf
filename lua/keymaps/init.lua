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
vim.keymap.set('n', 't', ':tabnext<CR>', { noremap = true, desc = 'Go to next [T]ab', silent = true })
vim.keymap.set('n', 'T', ':tabnew<CR>', { noremap = true, desc = 'Go to prev [T]ab', silent = true })
vim.keymap.set('n', 'H', ':tabnext #<CR>', { noremap = true, desc = 'Go to previously active [T]ab', silent = true })
vim.keymap.set('n', 'm', '<C-W><C-W>', { desc = 'Go to next Window', silent = true })
vim.keymap.set('n', 'M', '<C-W>p', { desc = 'Go to previously active Window', silent = true })
vim.keymap.set('n', 'L', ':b#<CR>', { desc = 'Go to last active buffer', silent = true })
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

for i = 1, 10, 1 do
  vim.keymap.set('n', '<a-' .. i .. '>', ':tabn ' .. i .. '<CR>', { desc = 'Go to tab ' .. i })
end

vim.keymap.set('n', '<leader>q', ':q<CR>', { silent = true })
vim.keymap.set('n', 'Q', ':q<CR>', { silent = true })

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
vim.keymap.set('n', '<leader>gg', function()
  vim.cmd '-tabnew | term lazygit'
  -- Fix for slow j scrolling because of jk escape
  -- Just now i can't type capital J or K :P
  vim.cmd "lua vim.keymap.set('t', 'J', 'j', {buffer = true})"
  vim.cmd "lua vim.keymap.set('t', 'K', 'k', {buffer = true})"
  vim.cmd 'startinsert'
end, { noremap = true })

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

vim.keymap.set('n', 'qw', '<C-W><C-O>', { silent = true })
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
vim.keymap.set('n', '<S-CR>', terminalNewTab, { desc = 'Terminal - New Tab' })
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
vim.keymap.set('n', 'qj', '<C-W>p', { desc = 'Swap Window', silent = true })
vim.keymap.set('n', 'qk', '$', { desc = 'End of line', silent = true })
vim.keymap.set('v', 'q', '$', { desc = 'End of line', silent = true })
vim.keymap.set('n', 'qd', 'dd', { desc = 'Delete line', silent = true })
vim.keymap.set('n', 'dq', 'dd', { desc = 'Delete line', silent = true })
