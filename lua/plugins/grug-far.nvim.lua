-- Make sure i have <localleader>?
-- TODO: Test bindings inside with <localleader>
-- TODO: Test ast-grep
return {
  'MagicDuck/grug-far.nvim',
  dependencies = {
    -- TODO: ast-grep?
  },
  keys = {
    {
      '<leader><leader>S',
      function()
        require('grug-far').open { visualSelectionUsage = 'operate-within-range' }
      end,
      desc = 'grug-far: Search within range',
      mode = { 'v', 'n', 'x' },
    },
    {
      '<leader>S',
      function()
        require('grug-far').open()
      end,
      desc = 'Grug',
      mode = { 'n', 'x' },
    },
    -- NOTE: 'v' mode with normal 'S' doesn't work cause of vim surround
    {
      'S',
      function()
        require('grug-far').open()
      end,
      desc = 'Grug',
      mode = { 'n' },
    },
  },
  cmd = { 'GrugFar', 'GrugFarWithin' },
  opts = {
    keymaps = {
      qflist = { n = 'q' },
      close = { n = '<localleader>q' },
    },
    prefills = {
      flags = '-i',
    },
  },
}
