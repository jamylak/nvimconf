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
vim.keymap.set('n', '<a-[>', ':tabprev<CR>', { desc = 'Go to previous [T]ab' })
vim.keymap.set('n', '<a-]>', ':tabnext<CR>', { desc = 'Go to next [T]ab' })
vim.keymap.set('i', '<a-[>', '<esc>:tabprev<CR>', { desc = 'Go to previous [T]ab' })
vim.keymap.set('i', '<a-]>', '<esc>:tabnext<CR>', { desc = 'Go to next [T]ab' })
vim.keymap.set('n', 'H', ':tabnext #<CR>', { noremap = true, desc = 'Go to previously active [T]ab', silent = true })
vim.keymap.set('n', 'm', '<C-W><C-W>', { desc = 'Go to next Window', silent = true })
vim.keymap.set('n', 'M', '<C-W>W', { desc = 'Go to previously active Window', silent = true })
vim.keymap.set('n', 'L', ':b#<CR>', { desc = 'Go to last active buffer', silent = true })
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

vim.keymap.set('n', 'HE', ':tabn 1<CR>', {})
vim.keymap.set('n', 'HR', ':tabn 2<CR>', {})
vim.keymap.set('n', 'HF', ':tabn 3<CR>', {})
vim.keymap.set('n', 'HU', ':tabn 4<CR>', {})
vim.keymap.set('n', 'HI', ':tabn 5<CR>', {})
vim.keymap.set('n', 'HO', ':tabn 6<CR>', {})

for i = 1, 8 do
  vim.keymap.set('n', '<a-' .. i .. '>', ':tabn ' .. i .. '<CR>', { desc = 'Go to tab ' .. i })
end
-- 9 = last tab
vim.keymap.set('n', '<a-9>', ':tabn $<cr>', { desc = 'Go to last tab' })
vim.keymap.set('n', '<a-s-[>', ':tabprev<cr>', { desc = 'Go to previous tab', silent = true })
vim.keymap.set('n', '<a-s-]>', ':tabnext<cr>', { desc = 'Go to next tab', silent = true })
vim.keymap.set('n', '<a-s-x>', ':tabclose<cr>', { desc = 'Close tab', silent = true })
vim.keymap.set('n', '<a-s-w>', ':tabclose<cr>', { desc = 'Close tab', silent = true })
vim.keymap.set('n', '<a-q>', ':tabclose<cr>', { desc = 'Close tab', silent = true })
vim.keymap.set('n', '<a-w>', ':tabclose<cr>', { desc = 'Close tab', silent = true })

local function find_terminal_buffer_number()
  -- Get the current tabpage
  local tabpage = vim.api.nvim_get_current_tabpage()
  -- Get all windows in the current tabpage
  local windows = vim.api.nvim_tabpage_list_wins(tabpage)

  for _, window in ipairs(windows) do
    -- Get the buffer number for each window
    local buf = vim.api.nvim_win_get_buf(window)
    -- Get the buffer type
    local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
    -- Check if the buffer type is terminal
    if buftype == 'terminal' then
      return buf
    end
  end

  return nil -- Return nil if no terminal buffer is found
end

function scroll_buffer_to_bottom(buf_id)
  -- Use nvim_buf_call to run commands in the context of the specified buffer
  vim.api.nvim_buf_call(buf_id, function()
    -- Execute the normal mode command 'G' to go to the end of the buffer
    vim.cmd 'normal! G'
  end)
end
local function sendTerminalRepeat(initialCommand)
  -- First find the open terminal buffer in the current tab
  local terminal_buffer = find_terminal_buffer_number()
  if terminal_buffer ~= nil then
    local chan = vim.api.nvim_buf_get_var(terminal_buffer, 'terminal_job_id')
    -- Now send the keys to the terminal
    if chan then
      if initialCommand then
        vim.fn.chansend(chan, initialCommand)
      else
        vim.fn.chansend(chan, 'r\r')
      end
      scroll_buffer_to_bottom(terminal_buffer)
    end
  else
    -- If no terminal is open, open one
    local bufname = vim.api.nvim_buf_get_name(0)
    local cmd = nil
    vim.cmd 'split | term'
    if bufname:match '%.py$' then
      -- Switch back to the original window
      vim.cmd 'wincmd p'
      cmd = 'python3 ' .. bufname .. ' \r'
      print('Initial Command set to: ' .. cmd)
      -- If we don't wait 100 ms then it sends the command but it
      -- doesn't run
      vim.defer_fn(function()
        sendTerminalRepeat(cmd)
      end, 100)
    else
      vim.cmd 'startinsert'
    end
  end
end
vim.api.nvim_create_user_command('M', sendTerminalRepeat, {})
vim.keymap.set('n', '<leader>n', sendTerminalRepeat, { desc = 'Send Repeart to terminal' })
vim.keymap.set('n', '<leader>m', ':make<CR>', { silent = true, desc = 'Run [M]ake' })
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
local function cdOpenLazyGitFloating()
  -- run cd
  -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('cd', true, true, true), 'n', true)
  openLazyGitFloating()
end
vim.keymap.set('n', '<leader>gh', openLazyGitFloating, { noremap = true })
vim.keymap.set('n', '<leader>gm', cdOpenLazyGitFloating, { noremap = true })

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
vim.keymap.set('i', 'JF', ';', { silent = true })
vim.keymap.set('i', '901', ';', { silent = true })
vim.keymap.set('i', '90e', ';', { silent = true })
vim.keymap.set('i', 'jfe', ';', { silent = true })
vim.keymap.set('i', 'jgr', ';', { silent = true })
vim.keymap.set('i', '902', '>', { silent = true })
vim.keymap.set('i', '903', '->', { silent = true })
vim.keymap.set('i', '904', ');', { silent = true })
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

vim.api.nvim_set_keymap('v', '<S-y>', '"+y', { noremap = true, silent = true })

-- Faster write
-- Only with function it doesn't come up as double write
vim.keymap.set('n', '<leader>w', function()
  vim.cmd 'w'
end, { silent = true })

-- Faster comment line
vim.api.nvim_set_keymap('n', 'co', 'gcc', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>c', 'gcc', { silent = true })
vim.api.nvim_set_keymap('v', '<leader>c', 'gc', { silent = true })

local changeDir = function()
  local file_path = vim.fn.expand '%:p'
  local dir_path = vim.fn.fnamemodify(file_path, ':h')
  vim.api.nvim_set_current_dir(dir_path)
end
vim.keymap.set('n', 'cd', changeDir, { desc = 'Change [C]urrent [D]irectory to parent of curfile' })

-- Useful keymaps
vim.keymap.set('n', '\\', ':split<CR>', { silent = true, desc = 'Vertical Split' })
vim.keymap.set('n', '|', ':vsplit<CR>', { silent = true, desc = 'Horizontal Split' })
vim.keymap.set('n', '<C-\\>', function()
  vim.cmd ':split | term'
  vim.cmd 'startinsert'
end, { silent = true, desc = 'Vertical Split' })
vim.keymap.set('n', '<C-S-\\>', function()
  vim.cmd ':vsplit | term'
  vim.cmd 'startinsert'
end, { silent = true, desc = 'Horizontal Split' })

vim.api.nvim_set_keymap('v', '<leader><leader>r', ':lua ExecuteVisualSelectionAsLua()<CR>', { noremap = true, desc = 'Execute lua' })
vim.api.nvim_set_keymap('n', '<leader><leader>s', ':source %<CR>', { noremap = true, desc = '[S]ource Lua File' })
vim.api.nvim_set_keymap('n', '<leader><leader>c', ':split | term zsh -l -c "cb; rn;"<CR>', { noremap = true, desc = '[c]make build and run ' })
vim.api.nvim_set_keymap('n', '<leader><leader>v', ':vsplit | term fish -c "cb; rn;"<CR>', { noremap = true, desc = '[c]make build and run vertical ' })
-- Leader Leader Y to yank whole file to clipboard
vim.api.nvim_set_keymap('n', '<leader><leader>y', 'ggVG"+y', { noremap = true, silent = true, desc = 'Yank whole file to clipboard' })
vim.api.nvim_set_keymap('n', '<leader>y', 'ggVG"+y', { noremap = true, silent = true, desc = 'Yank whole file to clipboard' })
-- vim.api.nvim_set_keymap('n', '<leader>y', 'gv"+y', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('v', '<leader>y', '"+y', { noremap = true, silent = true })

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
vim.keymap.set('n', '<a-t>', ':tabnew<CR>', { desc = 'New Tab' })
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
vim.keymap.set('n', 'qb', '<cmd>normal sfb<CR>', { desc = 'Surrounding bracket', silent = true })
vim.keymap.set('n', 'qv', '<cmd>normal sfnb<CR>', { desc = 'Next surrounding bracket', silent = true })
vim.keymap.set('n', 'qo', '<cmd>normal vxov<CR>', { desc = 'Cursor to root TS node', silent = true })
vim.keymap.set('n', 'sh', '<C-W>p', { desc = '[S]wap [W]indow', silent = true })
vim.keymap.set('n', 'qk', '$', { desc = 'End of line', silent = true })
vim.keymap.set('n', 'qi', '>>', { desc = 'Indent', silent = true })
vim.keymap.set('n', 'qg', 'G', { desc = 'Go to end of file', silent = true })
vim.keymap.set('n', 'gl', 'G', { desc = 'Go to end of file', silent = true })
vim.keymap.set('n', 'gp', 'G', { desc = 'Go to end of file', silent = true })
vim.keymap.set('n', 'qp', 'yyp', { desc = 'Yank and paste current line', silent = true })
vim.keymap.set('v', 'q', '$', { desc = 'End of line', silent = true })
vim.keymap.set('v', '<c-p>', 'ygvvo<esc>pO<esc>j', { desc = 'Duplicate current selection below', silent = true })
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

local function cd_to_git_root()
  -- Execute the git command to find the root
  local handle = io.popen('git -C ' .. vim.fn.expand '%:p:h' .. ' rev-parse --show-toplevel')
  local result = handle:read '*a'
  handle:close()

  -- Trim whitespace from the result
  result = string.gsub(result, '%s+$', '')

  if result == '' then
    print 'Not a git repository or some other error occurred'
  else
    -- Change the directory
    vim.cmd('cd ' .. vim.fn.fnameescape(result))
    print('Changed directory to ' .. result)
  end
end

vim.keymap.set('n', '<leader>v', cd_to_git_root, { noremap = true })
vim.keymap.set('n', '<leader>bc', cd_to_git_root, { noremap = true })

-- Ctrl Insert key combos
-- vim.keymap.set('i', '<C-j>', '<c-o>w', { silent = true })
vim.keymap.set('i', '<C-d>', '<c-o>b', { silent = true })
vim.keymap.set('i', '<C-s>', '<c-o>^', { silent = true })
vim.keymap.set('i', '<C-x>', '<c-o>x', { silent = true })
vim.keymap.set('i', '<C-h>', '<c-o><leader>w', { silent = true })

-- Faster way to do common symbols
-- vim.keymap.set('i', '<C-i><C-i>', ',', { silent = true })
vim.keymap.set('i', '<C-f>j', ',', { silent = true })
vim.keymap.set('i', '<C-f><C-j>', '.', { silent = true, noremap = true })
vim.keymap.set('i', '<C-9>', ',', { silent = true, noremap = true })
vim.keymap.set('i', '<C-0>', '.', { silent = true, noremap = true })
vim.keymap.set('i', '<C-g>', '.', { silent = true, noremap = true })
vim.keymap.set('i', '<C-i>', ';', { silent = true, noremap = true })
vim.keymap.set('i', '<C-->', ';', { silent = true, noremap = true })
vim.keymap.set('i', '<C-f><C-k>', ';', { silent = true, noremap = true })

-- Create a new project
local function newProj()
  require('telescope').extensions.file_browser.file_browser {
    cwd = '~/bar',
    attach_mappings = function(prompt_bufnr, map)
      -- Define what happens when you press Enter
      map('i', '<CR>', function()
        -- Get the current input text
        local current_input = require('telescope.actions.state').get_current_line()
        print('Current input: ' .. current_input)
        require('telescope.actions').close(prompt_bufnr)
        local path = '~/bar/' .. current_input
        vim.fn.mkdir(vim.fn.expand(path), 'p')
        vim.cmd('e ' .. path)
      end)
      return true -- Return true to keep default mappings as well
    end,
  }
end

vim.keymap.set('n', '<leader><leader>b', newProj, { desc = 'New Project' })
