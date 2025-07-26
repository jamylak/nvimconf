-- Disable this so there's no delay calling <c-g> lazygit
-- in insert mode
local utils = require 'utils'
vim.g.surround_no_insert_mappings = 1
return {
  'tpope/vim-surround',
  ft = utils.sourceFileTypes,
}
