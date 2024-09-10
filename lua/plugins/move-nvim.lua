return {
  'fedepujol/move.nvim',
  keys = {
    { '<C-j>', ':MoveBlock(1)<CR>', mode = 'v', desc = 'Move block down', silent = true },
    { '<C-k>', ':MoveBlock(-1)<CR>', mode = 'v', desc = 'Move block up', silent = true },
    -- { '<C-h>', ':MoveHBlock(-1)<CR>', mode = 'v', desc = 'Move block left', silent = true },
    -- { '<C-l>', ':MoveHBlock(1)<CR>', mode = 'v', desc = 'Move block right', silent = true },
    { '<C-j>', ':MoveLine(1)<CR>', mode = 'n', desc = 'Move block down', silent = true },
    { '<C-k>', ':MoveLine(-1)<CR>', mode = 'n', desc = 'Move block up', silent = true },
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
  -- vim.keymap.set('n', '<A-h>', ':MoveHChar(-1)<CR>', opts)
  -- vim.keymap.set('n', '<A-l>', ':MoveHChar(1)<CR>', opts)
  -- vim.keymap.set('n', '<leader>wf', ':MoveWord(1)<CR>', opts)
  -- vim.keymap.set('n', '<leader>wb', ':MoveWord(-1)<CR>', opts)
}
