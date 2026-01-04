local utils = require 'utils'

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
