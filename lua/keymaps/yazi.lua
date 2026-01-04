local utils = require 'utils'

-- Yazi
-- Based off this https://www.reddit.com/r/HelixEditor/comments/1j72tmr/use_yazi_file_manager_directly_in_helix_without/
vim.keymap.set('n', '<A-y>', function()
  utils.yazi()
end, { noremap = true, silent = true })

vim.keymap.set('n', '<C-y>', function()
  -- TODO: Maybe just run the fzf and get the output from it
  -- then open new tab, directly CD there, set the TCD...
  vim.cmd 'tabnew'
  utils.yazi()
end, { noremap = true, silent = true })
