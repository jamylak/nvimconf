local utils = require 'utils'

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Keymap to do search with <c-s> eg. same as / but with <c-s>
vim.keymap.set('n', '<C-s>', '/', { silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })

-- Next quickfix eg. like :cn or :cp but for ]q and [q
vim.keymap.set('n', ']q', ':cnext<CR>', { desc = 'Go to next [Q]uickfix' })
vim.keymap.set('n', '[q', ':cprev<CR>', { desc = 'Go to previous [Q]uickfix' })

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
vim.keymap.set('n', '<a-d>', '<C-W><C-W>', { desc = 'Go to next Window', silent = true })
vim.keymap.set('n', 'm', '<C-W><C-W>', { desc = 'Go to prev Window', silent = true })
vim.keymap.set('n', 'L', ':b#<CR>', { desc = 'Go to last active buffer', silent = true })
vim.keymap.set('n', 'M', '<C-W>W', { desc = 'Go to previously active Window', silent = true })
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
  vim.keymap.set(mode, 'gk[', cmd .. ':tabn 3<CR>', {})
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
  vim.keymap.set('n', '<leader>t' .. i, ':tabn ' .. i .. '<CR>', { desc = 'Go to tab ' .. i })
end
-- 9 = last tab
vim.keymap.set('n', '<a-9>', ':tabn $<cr>', { desc = 'Go to last tab' })
vim.keymap.set('n', '<a-s-[>', ':tabprev<cr>', { desc = 'Go to previous tab', silent = true })
vim.keymap.set('n', '<a-s-]>', ':tabnext<cr>', { desc = 'Go to next tab', silent = true })
vim.keymap.set('n', '<a-s-x>', ':tabclose<cr>', { desc = 'Close tab', silent = true })
vim.keymap.set('n', '<a-s-w>', ':tabclose<cr>', { desc = 'Close tab', silent = true })

vim.keymap.set('n', '<a-w>', utils.CloseTabOrQuit, { desc = 'Close tab', silent = true })
vim.keymap.set('n', '<a-q>', ':q!<cr>', { desc = 'Close nvim', silent = true })

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
  -- First send a write command to write current file
  vim.cmd 'write'
  -- Then find the open terminal buffer in the current tab
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

    -- We can't run
    --      vim.cmd('split | term fish -c "' .. cmd .. '"; exec fish')
    --  cmd = 'python3 ' .. bufname
    -- Cause then it won't easily repeat the last command
    if bufname:match '%.py$' then
      -- Switch back to the original window
      vim.cmd 'wincmd p'
      cmd = 'python3 ' .. bufname .. ' \r'
      print('Initial Command set to: ' .. cmd)
      -- If we don't wait 100 ms then it sends the command but it
      -- doesn't run
      vim.defer_fn(function()
        sendTerminalRepeat(cmd)
      end, 220)
    else
      vim.cmd 'startinsert'
    end
  end
end
vim.api.nvim_create_user_command('M', sendTerminalRepeat, {})
vim.keymap.set('n', '<leader>n', sendTerminalRepeat, { desc = 'Send Repeart to terminal' })
vim.keymap.set('n', '<leader>m', ':make<CR>', { silent = true, desc = 'Run [M]ake' })
vim.keymap.set('n', '<leader>q', ':q!<CR>', { silent = true })
vim.keymap.set('n', '<leader>Q', ':qall!<CR>', { silent = true })
vim.keymap.set('n', 'Q', ':qall!<CR>', { silent = true })

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
vim.keymap.set('n', '<leader>gg', function()
  local utils = require 'utils'
  utils.lazygit()
end, { noremap = true })

vim.keymap.set('n', '<m-g>', function()
  local utils = require 'utils'
  utils.lazygit()
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

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { silent = true })

-- Allow jk and ji escape in terminal mode but not in yazi or lazygit
-- to allow easy navigation
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = '*',
  callback = function()
    if not vim.api.nvim_buf_get_name(0):match 'yazi' and not vim.api.nvim_buf_get_name(0):match 'lazygit' then
      vim.keymap.set('t', 'jk', '<C-\\><C-n>', { buffer = true, silent = true })
      vim.keymap.set('t', 'ji', '<C-\\><C-n>', { buffer = true, silent = true })
    end
  end,
})

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
vim.api.nvim_set_keymap('n', '<C-c>', 'gcc', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>c', 'gcc', { silent = true })
vim.api.nvim_set_keymap('v', '<leader>c', 'gc', { silent = true })
vim.api.nvim_set_keymap('v', '<C-c>', 'gc', { silent = true })

local changeDir = function()
  local file_path = vim.fn.expand '%:p'
  local dir_path = vim.fn.fnamemodify(file_path, ':h')
  vim.api.nvim_set_current_dir(dir_path)
end
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
-- vim.keymap.set('n', 'cd', changeDir, { desc = 'Change [C]urrent [D]irectory to parent of curfile' })
vim.keymap.set('n', 'cd', changeDirTab, { desc = 'Tab Change [C]urrent [D]irectory to parent of curfile' })

-- Useful keymaps
vim.keymap.set('n', '\\', ':split<CR>', { silent = true, desc = 'Vertical Split' })
vim.keymap.set('n', '<leader>\\', function()
  vim.fn.system('fish -c "yazi_hsplit ' .. vim.fn.expand '%:p' .. '"')
end, { silent = true, desc = 'Yazi - Vertical Split' })
vim.keymap.set('n', '|', ':vsplit<CR>', { silent = true, desc = 'Horizontal Split' })
vim.keymap.set('n', '<leader>|', function()
  vim.fn.system('fish -c "yazi_vsplit ' .. vim.fn.expand '%:p' .. '"')
end, { silent = true, desc = 'Yazi - Vertical Split' })
vim.keymap.set('n', '<leader>I', function()
  vim.fn.system('fish -c "yazi_new_tab ' .. vim.fn.expand '%:p' .. '"')
end, { silent = true, desc = 'Yazi - Tab' })
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
-- Leader Y to yank whole file to clipboard
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

vim.keymap.set('n', '<a-t>', ':split<CR><C-w>T', { desc = 'New Tab' })
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
vim.keymap.set('n', '<c-e>', '$', { desc = 'End of line', silent = true })
vim.keymap.set('v', '<c-e>', '$', { desc = 'End of line', silent = true })
vim.keymap.set('n', '<c-a>', '0', { desc = 'End of line', silent = true })
vim.keymap.set('v', '<c-a>', '0', { desc = 'Start of line', silent = true })
vim.keymap.set('n', '<c-h>', '$', { desc = 'End of line', silent = true })
vim.keymap.set('n', 'qi', '>>', { desc = 'Indent', silent = true })
vim.keymap.set('n', 'qg', 'G', { desc = 'Go to end of file', silent = true })
vim.keymap.set('n', 'gl', '$', { desc = 'Go to end of line', silent = true })
vim.keymap.set('n', 'ge', 'G', { desc = 'Go to end of file', silent = true })
vim.keymap.set('n', 'gp', 'G', { desc = 'Go to end of file', silent = true })
vim.keymap.set('n', 'qp', 'yyp', { desc = 'Yank and paste current line', silent = true })
vim.keymap.set('n', '<c-p>', 'yyp', { desc = 'Yank and paste current line', silent = true })
vim.keymap.set('v', 'q', '$h', { desc = 'End of line', silent = true })
vim.keymap.set('n', '<m-x>', ':', { desc = 'Command', silent = true })

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

-- not yet going straight to insert mode
vim.api.nvim_create_user_command('TERM', function()
  utils.terminalNewTab()
end, {})

-- Ctrl Insert key combos
-- vim.keymap.set('i', '<C-j>', '<c-o>w', { silent = true })
-- vim.keymap.set('i', '<C-d>', '<c-o>b', { silent = true })
vim.keymap.set('i', '<C-s>', '<c-o>^', { silent = true })
vim.keymap.set('i', '<C-x>', '<c-o>x', { silent = true })
vim.keymap.set('i', '<C-h>', '<c-o><leader>w', { silent = true })

-- Faster way to do common symbols
-- vim.keymap.set('i', '<C-i><C-i>', ',', { silent = true })
vim.keymap.set('i', '<C-9>', ',', { silent = true, noremap = true })
vim.keymap.set('i', '<C-0>', '.', { silent = true, noremap = true })
vim.keymap.set('i', '<C-g>', '.', { silent = true, noremap = true })
vim.keymap.set('i', '<C-i>', ';', { silent = true, noremap = true })
vim.keymap.set('i', '<C-->', ';', { silent = true, noremap = true })

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

local function openCurrentFileInHelix()
  local filename = vim.fn.expand '%:p'
  local line_number = vim.fn.line '.'
  local escaped_filename = "'" .. filename .. "'"
  local helix_cmd = 'hx_new_tab ' .. escaped_filename .. ' ' .. line_number
  local cmd = 'fish -c "' .. helix_cmd .. '"'
  print(cmd)
  vim.fn.system(cmd)
end

vim.api.nvim_set_keymap('n', '<leader><leader>y', ':let @+ = expand("%:p")<CR>', { desc = 'Yank filename to clipboard', noremap = true, silent = true })
vim.keymap.set('n', '<leader>Y', openCurrentFileInHelix, { desc = 'Open current file in helix' })
vim.keymap.set('n', '<leader>H', openCurrentFileInHelix, { desc = 'Open current file in helix' })
vim.keymap.set('n', '<leader><leader>Y', openCurrentFileInHelix, { desc = 'Open current file in helix' })

vim.api.nvim_create_user_command('NT', ':Neotree', {})
vim.api.nvim_create_user_command('J', ':Neotree', {})
vim.api.nvim_create_user_command('L', ':Neotree', {})

vim.keymap.set('i', '<C-f>', '<Right>', { silent = true })
vim.keymap.set('i', '<C-a>', '<Home>', { silent = true })
vim.keymap.set('i', '<C-e>', '<End>', { silent = true })
vim.keymap.set('i', '<C-b>', '<Left>', { silent = true })
vim.keymap.set('i', '<C-p>', '<Up>', { silent = true })
vim.keymap.set('i', '<C-n>', '<Down>', { silent = true })
vim.keymap.set('i', '<C-d>', '<Del>', { silent = true })
-- vim.keymap.set('i', '<C-k>', '<c-o>D', { silent = true })
-- Define the Lua function to handle the key mapping logic
local function check_and_delete()
  local col = vim.fn.col '.'
  local line = vim.fn.getline '.'
  if col <= #line then
    -- If the cursor is not at the end of the line, delete the characters after the cursor
    return '<C-o>D'
  else
    -- If the cursor is at the end of the line, join with the next line
    return '<C-o>J'
  end
end

-- Set the key mapping for Ctrl-K in insert mode
vim.keymap.set('i', '<C-k>', check_and_delete, { expr = true, noremap = true })
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

function GitHubURL()
  local utils = require 'utils'
  utils.cd_to_git_root()
  local file = vim.fn.expand '%'
  local line = vim.fn.line '.'
  local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  local rel_path = vim.fn.fnamemodify(file, ':.')

  local remote_url = vim.fn.systemlist('git config --get remote.origin.url')[1]
  if remote_url:find 'git@' then
    remote_url = remote_url:gsub(':', '/'):gsub('git@', 'https://'):gsub('%.git$', '')
  elseif remote_url:find 'https://' then
    remote_url = remote_url:gsub('%.git$', '')
  end

  local branch = vim.fn.systemlist('git rev-parse --abbrev-ref HEAD')[1]

  return string.format('%s/blob/%s/%s#L%d', remote_url, branch, rel_path, line)
end

function CopyGitHubURLToClipboard()
  local url = GitHubURL()
  vim.fn.setreg('+', url) -- Copies URL to clipboard
  print('GitHub URL copied: ' .. url)
  return url
end

function launchGitHubUrl()
  local url = CopyGitHubURLToClipboard()
  vim.fn.system('open ' .. url)
end

vim.keymap.set('n', '<leader><leader>G', CopyGitHubURLToClipboard, { desc = 'Copy GitHub URL' })
vim.keymap.set('n', '<leader><leader>g', launchGitHubUrl, { desc = 'Launch GitHub URL' })

-- Yazi
-- Based off this https://www.reddit.com/r/HelixEditor/comments/1j72tmr/use_yazi_file_manager_directly_in_helix_without/
vim.keymap.set('n', '<A-y>', function()
  local utils = require 'utils'
  utils.yazi()
end, { noremap = true, silent = true })

vim.keymap.set('n', '<C-y>', function()
  -- TODO: Maybe just run the fzf and get the output from it
  -- then open new tab, directly CD there, set the TCD...
  vim.cmd 'tabnew'
  local utils = require 'utils'
  utils.yazi()
end, { noremap = true, silent = true })

function HasNonTelescopeBuf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if name ~= '' and not name:match 'TelescopePrompt' then
      return true
    end
  end
  return false
end
