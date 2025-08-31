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
      '<leader>S',
      function()
        require('grug-far').open()
      end,
      desc = 'Replace within text',
      mode = { 'v', 'n' }
    },
    -- NOTE: 'v' mode with normal 'S' doesn't work
    {
      'S',
      function()
        require('grug-far').open()
      end,
      desc = 'Replace within text',
      mode = { 'v', 'n' }
    },
  },
  cmd = { 'GrugFar', 'GrugFarWithin' },
  opts = {
    keymaps = {
      qflist = { n = 'q' },
      close = { n = '<localleader>q' },
    },
    prefills = {
      flags = '-i'
    }
  },
}
