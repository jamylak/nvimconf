-- Make sure i have <localleader>?
-- TODO: Test bindings inside with <localleader>
-- TODO: Test ast-grep
return {
  'MagicDuck/grug-far.nvim',
  dependencies = {
    -- TODO: ast-grep?
  },
  keys = {
    { 'S',         '<cmd>GrugFar<cr>', desc = 'Replace in text' },
  },
  cmd = { 'GrugFar', 'GrugFarWithin' },
  opts = {
    prefills = {
      flags = '-i'
    }
  },
}
