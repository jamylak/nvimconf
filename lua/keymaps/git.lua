local utils = require 'utils'

function GitHubURL()
  utils.cd_to_git_root()
  local file = vim.fn.expand '%'
  local line = vim.fn.line '.'
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
  print 'GH URL copied'
  return url
end

function launchGitHubUrl()
  local url = CopyGitHubURLToClipboard()
  vim.fn.system('open ' .. url)
end

vim.api.nvim_create_user_command('CD', function()
  utils.cd_to_git_root()
end, {})

vim.api.nvim_create_user_command('TCD', function()
  utils.tcd_to_git_root()
end, {})

vim.keymap.set('n', '<leader>v', utils.tcd_to_git_root, { noremap = true })
vim.keymap.set('n', '<leader>V', utils.cd_to_git_root, { noremap = true })
vim.keymap.set('n', '<m-v>', utils.cd_to_git_root, { noremap = true })
vim.keymap.set('n', '<leader>bc', utils.cd_to_git_root, { noremap = true })
vim.keymap.set('n', '<leader><leader>G', CopyGitHubURLToClipboard, { desc = 'Copy GitHub URL' })
vim.keymap.set('n', '<leader><leader>g', launchGitHubUrl, { desc = 'Launch GitHub URL' })
