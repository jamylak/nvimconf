return {
  'fedepujol/move.nvim',
  keys = {
    { '<C-j>', ':MoveBlock(1)<CR>', mode = 'v', desc = 'Move block down' },
    { '<C-k>', ':MoveBlock(-1)<CR>', mode = 'v', desc = 'Move block up' },
    { '<C-h>', ':MoveHBlock(-1)<CR>', mode = 'v', desc = 'Move block left' },
    { '<C-l>', ':MoveHBlock(1)<CR>', mode = 'v', desc = 'Move block right' },
  },
  opts = {
    line = {
      enable = true, -- Enables line movement
      indent = true, -- Toggles indentation
    },
    block = {
      enable = true, -- Enables block movement
      indent = true, -- Toggles indentation
    },
    word = {
      enable = true, -- Enables word movement
    },
    char = {
      enable = true, -- Enables char movement
    },
  },
  -- Normal-mode commands
  -- Turn off the normal mode one for now,
  -- Later may turn them on but visual is enough for the moment
  -- vim.keymap.set('n', '<A-j>', ':MoveLine(1)<CR>', opts)
  -- vim.keymap.set('n', '<A-k>', ':MoveLine(-1)<CR>', opts)
  -- vim.keymap.set('n', '<A-h>', ':MoveHChar(-1)<CR>', opts)
  -- vim.keymap.set('n', '<A-l>', ':MoveHChar(1)<CR>', opts)
  -- vim.keymap.set('n', '<leader>wf', ':MoveWord(1)<CR>', opts)
  -- vim.keymap.set('n', '<leader>wb', ':MoveWord(-1)<CR>', opts)
}
