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

vim.keymap.set('n', '<leader>i', function()
  local manager = require 'neo-tree.sources.manager'
  local renderer = require 'neo-tree.ui.renderer'

  local state = manager.get_state 'filesystem'
  local window_exists = renderer.window_exists(state)

  local commands = require 'neo-tree.sources.filesystem.commands'
  -- If Neotree is visible ex
  if window_exists then
    vim.cmd 'Neotree close'
  else
    vim.cmd 'Neotree reveal'
    vim.cmd 'wincmd p'
  end
end, { desc = '[N]eotree - Reveal' })

vim.keymap.set('n', '<leader><leader>T', function()
  vim.cmd 'Neotree toggle'
  vim.defer_fn(expandAllNeoTreeNodes, 50)
end, { desc = '[N]eotree - Toggle & Expand & Focus' })

-- vim.keymap.set('n', '<leader>j', function()
--   vim.cmd 'Neotree toggle'
--   vim.defer_fn(expandAllNeoTreeNodes, 50)
--   vim.cmd 'wincmd p'
-- end, { desc = '[N]eotree - Toggle & Expand' })
--
-- vim.keymap.set('n', '<leader>k', function()
--   vim.cmd 'Neotree toggle'
--   vim.cmd 'wincmd p'
-- end, { desc = '[N]eotree - Toggle' })

vim.keymap.set('n', '<leader><leader>t', function()
  vim.cmd 'Neotree toggle'
  vim.defer_fn(expandAllNeoTreeNodes, 50)
  vim.cmd 'wincmd p'
end, { desc = '[N]eotree - Toggle & Expand' })

-- Neotree collapse all
-- vim.keymap.set('n', '<leader><leader>z', function()
-- end, { desc = '[N]eotree - Collapse' })

vim.keymap.set('n', '<leader><leader>x', function()
  expandAllNeoTreeNodes()
end, { desc = '[N]eotree - Expand' })
return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  cmd = 'Neotree',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  opts = {
    -- enable_git_status = true,
    enable_diagnostics = true,
    filesystem = {
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every time
        --              -- the current file is changed while the tree is open.
        -- leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
    },
    window = {
      mappings = {
        ['z'] = 'close_all_nodes',
        ['Z'] = 'expand_all_nodes',
      },
    },
  },
}
