local function expandAllNeoTreeNodes()
  -- https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/826#discussioncomment-5431757
  local manager = require 'neo-tree.sources.manager'
  local renderer = require 'neo-tree.ui.renderer'

  local state = manager.get_state 'filesystem'
  local window_exists = renderer.window_exists(state)

  local commands = require 'neo-tree.sources.filesystem.commands'
  -- If Neotree is visible ex
  if window_exists then
    commands.expand_all_nodes(state, nil)
  end
end

vim.keymap.set('n', '<leader>nn', function()
  vim.cmd 'Neotree toggle'
  vim.defer_fn(expandAllNeoTreeNodes, 50)
end, { desc = '[N]eotree - Toggle' })
vim.keymap.set('n', '<leader><leader>x', function()
  expandAllNeoTreeNodes()
end, { desc = '[N]eotree - Toggle' })
return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  cmd = 'Neotree',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  opts = {
    window = {
      mappings = {
        ['z'] = 'close_all_nodes',
        ['Z'] = 'expand_all_nodes',
      },
    },
  },
}
