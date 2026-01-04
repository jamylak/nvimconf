function HasNonTelescopeBuf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if name ~= '' and not name:match 'TelescopePrompt' then
      return true
    end
  end
  return false
end

function IsNonEmptyBuffer()
  local buf = vim.api.nvim_get_current_buf()
  local name = vim.api.nvim_buf_get_name(buf)
  return name ~= ''
end

-- Untested
function DoesCurrentWindowHaveNonEmptyBuffer()
  local win = vim.api.nvim_get_current_win()
  local bufs = vim.api.nvim_list_bufs()
  for _, buf in ipairs(bufs) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_win_is_buf(win, buf) then
      if vim.api.nvim_buf_get_name(buf) ~= '' then
        return true
      end
    end
  end
  return false
end

local utils = require 'utils'
vim.keymap.set('n', '<m-n>', utils.fzfDir)
vim.keymap.set('i', '<m-n>', utils.fzfDir)
vim.api.nvim_create_user_command('F', utils.fzfDir, {})

-- I should be able to do a search eg. /foo
-- and then it takes me to whatever window that terms is in
vim.keymap.set('n', '<leader>W', utils.searchAcrossWindows, { desc = 'Search across all windows and jump to match' })
vim.keymap.set('n', 'H', utils.searchAcrossWindows, { desc = 'Search across all windows and jump to match' })
