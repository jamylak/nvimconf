local M = {}

function M.get_git_root(path)
  -- If we pass in a path, use that to get the git root
  -- from, otherwise get the current buffer
  if not path then
    path = vim.fn.expand '%:p:h'
    if string.match(path, '^oil://') then
      path = string.sub(path, 7)
    end
  elseif vim.fn.isdirectory(path) == 0 then
    path = vim.fn.fnamemodify(path, ':h')
  end

  -- Execute the git command to find the root
  local handle = io.popen('git -C ' .. path .. ' rev-parse --show-toplevel')
  local result = handle:read '*a'
  handle:close()

  -- Trim whitespace from the result
  result = string.gsub(result, '%s+$', '')

  if result == '' then
    return ''
  else
    return vim.fn.fnameescape(result)
  end
end

function M.cd_to_git_root(path)
  path = M.get_git_root(path)
  if path == '' then
    print 'Not a git repository or some other error occurred'
  else
    -- Change the directory
    vim.cmd('cd ' .. path)
    -- print('Changed directory to ' .. path)
  end
end

function M.tcd_to_git_root(path)
  path = M.get_git_root(path)
  if path == '' then
    -- vim.notify('Not a git repository or some other error occurred', vim.log.levels.DEBUG)
    return false
  else
    -- Change the tab directory
    vim.cmd('tcd ' .. path)
    return true
  end
end

function M.CloseTabOrQuit()
  if #vim.api.nvim_list_tabpages() > 1 then
    vim.cmd 'tabclose'
  else
    vim.cmd 'qa!'
  end
end

function M.terminalNewTab()
  vim.cmd 'tabnew | term'
  -- delay
  vim.defer_fn(function()
    vim.cmd 'startinsert'
  end, 50)
end

function M.terminalVSplit()
  vim.cmd 'vsplit | term'
  vim.cmd 'startinsert'
end

function M.terminalHSplit()
  vim.cmd 'split | term'
  vim.cmd 'startinsert'
end

function M.yazi(path)
  -- Remove old path file
  vim.fn.system 'rm -f /tmp/yazi-nvim-path'

  local path = path or vim.fn.bufname '%'

  -- Open Yazi in a floating terminal and capture the buffer ID
  vim.cmd('-tabnew | term yazi ' .. path .. ' --chooser-file=/tmp/yazi-nvim-path')
  vim.cmd 'startinsert'
  local term_buf = vim.api.nvim_get_current_buf()

  -- Scoped TermClose for that terminal buffer only
  vim.api.nvim_create_autocmd('TermClose', {
    buffer = term_buf,
    callback = function()
      -- If the terminal is still waiting for input..
      -- eg. we pressed 'q' in yazi, Send a newline to close it
      vim.api.nvim_input '<CR>'
      local path = vim.fn.readfile('/tmp/yazi-nvim-path')[1] or ''
      -- vim.cmd 'tabclose'
      -- vim.api.nvim_buf_delete(term_buf, { force = true })
      if path ~= '' then
        -- Without defer, LSP doesn't load
        vim.defer_fn(function()
          vim.cmd('edit ' .. path)
          vim.cmd 'TCD'
        end, 20)
      end
      vim.cmd 'redraw'
    end,
  })
end

function M.fff()
  -- Currently need to close and schedule due to some bugs
  require('fff.picker_ui').close()
  vim.schedule(function()
    require("fff").find_files()
    vim.schedule(function()
      vim.cmd 'startinsert'
    end)
  end)
end

function M.fzfDir()
  -- TODO: /tmp and then it will do CD instead of git root?
  local dirs = vim.fn.split(vim.fn.system [[ls -dt /tmp ~/bar/* ~/proj/* ~/.config/dotfiles ~/.config/nvim 2>/dev/null]],
    '\n')

  require('telescope.pickers')
      .new({}, {
        prompt_title = 'Select Project',
        finder = require('telescope.finders').new_table {
          results = dirs,
        },
        sorter = require('telescope.config').values.generic_sorter {},
        attach_mappings = function(_, map)
          local function projTabFindFiles(path)
            if path and path ~= '' then
              if IsNonEmptyBuffer() then
                vim.cmd 'tabnew'
              end
              vim.cmd('tcd ' .. path)
              -- vim.cmd 'Telescope find_files'
              M.fff()
            end
          end
          map('i', '<CR>', function(prompt_bufnr)
            local selection = require('telescope.actions.state').get_selected_entry()
            require('telescope.actions').close(prompt_bufnr)
            local path = selection[1]
            projTabFindFiles(path)
          end)
          map('i', '<C-CR>', function(prompt_bufnr)
            local selection = require('telescope.actions.state').get_selected_entry()
            require('telescope.actions').close(prompt_bufnr)
            local path = selection[1]
            if path and path ~= '' then
              local utils = require 'utils'
              if not utils.switchToTabWithFile(path .. '/') then
                projTabFindFiles(path)
              end
            end
          end)
          map('i', '<C-j>', function(prompt_bufnr)
            local selection = require('telescope.actions.state').get_selected_entry()
            require('telescope.actions').close(prompt_bufnr)
            local path = selection[1]
            if path and path ~= '' then
              local utils = require 'utils'
              if not utils.switchToTabWithFile(path .. '/') then
                projTabFindFiles(path)
              end
            end
          end)
          map('i', '<S-CR>', function(prompt_bufnr)
            local action_state = require 'telescope.actions.state'
            local actions = require 'telescope.actions'
            local input = action_state.get_current_line()
            if input and input ~= '' then
              local dir = vim.fn.expand('~/bar/' .. input)
              actions.close(prompt_bufnr)
              -- vim.schedule(function()
              vim.fn.mkdir(dir, 'p')
              if IsNonEmptyBuffer() then
                vim.cmd 'tabnew'
              end
              vim.cmd('tcd ' .. dir)
              -- vim.cmd 'Telescope find_files'
              M.fff()
            end
          end)
          return true
        end,
      })
      :find()
end

function M.lazygit()
  vim.cmd '-tabnew | term lazygit'
  vim.cmd 'startinsert'
end

function M.switchToTabWithFile(filepath)
  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
      local buf = vim.api.nvim_win_get_buf(win)
      local name = vim.api.nvim_buf_get_name(buf)
      if name:find(filepath, 1, true) then
        vim.api.nvim_set_current_tabpage(tab)
        return true
      end
    end
  end
  return false
end

local function focusExplorerInput()
  -- Focus on filetype snacks_picker_input
  -- in the current tabpage
  local tab = vim.api.nvim_get_current_tabpage()
  local wins = vim.api.nvim_tabpage_list_wins(tab)
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
    if ft == 'snacks_picker_input' then
      vim.api.nvim_set_current_win(win)
      vim.cmd 'startinsert'
      return true
    end
  end
  -- Didn't find it
  return false
end

function M.searchExplorer()
  if focusExplorerInput() then
    return
  end
  -- No explorer input in tabpage, open one
  Snacks.explorer.open()
  vim.defer_fn(focusExplorerInput, 10)
end

function M.toggleExplorer()
  local e = Snacks.explorer()
  if e then
    -- means we switched to the picker
    -- switch back
    vim.defer_fn(function()
      vim.cmd("wincmd p")
      -- print("Switch back")
    end, 10)
  end
end

-- Should it have auto highlight as you type or something?
-- Maybe not needed cause it's quick...
-- TODO: Make it also search the titles that show up too
-- TODO: Search the virtual text too?
-- TODO: Should empty repeat last search?
-- TODO: Maybe it waits to see when some basic title or something
-- comes in eg. for Trouble to give it better titles
function M.searchAcrossWindows()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local term = vim.fn.input("Search across windows: ")
  if term == "" then
    -- If no search term then get it from the slash register
    term = vim.fn.getreg('/')
  end

  local cur_win = vim.api.nvim_get_current_win()

  for _, win in ipairs(wins) do
    -- If it is the current window skip it
    if win == cur_win then
      goto continue
    end

    local buf = vim.api.nvim_win_get_buf(win)

    -- get top and bottom visible lines in this window
    local top = vim.fn.line("w0", win)
    local bot = vim.fn.line("w$", win)

    local lines = vim.api.nvim_buf_get_lines(buf, top - 1, bot, false)

    -- all lines
    -- local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    --
    for i, line in ipairs(lines) do
      if line:lower():find(term:lower(), 1, true) then
        -- Now that we found it save the search term
        -- to the slash register in case we need to press n or N
        -- to find next or previous match
        vim.fn.setreg('/', term)

        vim.api.nvim_set_current_win(win)
        local col = line:lower():find(term:lower(), 1, true) - 1
        vim.api.nvim_win_set_cursor(win, { top + i - 1, col })
        return
      end
    end
    ::continue::
  end

  print("No match for '" .. term .. "' in any window")
  vim.api.nvim_set_current_win(cur_win)
end

return M
