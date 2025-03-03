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
    print 'Not a git repository or some other error occurred'
  else
    -- Change the tab directory
    vim.cmd('tcd ' .. path)
  end
end

function M.CloseTabOrQuit()
  if #vim.api.nvim_list_tabpages() > 1 then
    vim.cmd 'tabclose'
  else
    vim.cmd 'qa!'
  end
end

return M
