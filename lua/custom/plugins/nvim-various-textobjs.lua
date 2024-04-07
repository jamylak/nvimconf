local keymap = vim.keymap.set
keymap({ 'o', 'x' }, 'id', "<cmd>lua require('various-textobjs').number('inner')<CR>")
keymap({ 'o', 'x' }, 'ad', "<cmd>lua require('various-textobjs').number('outer')<CR>")

return {
  'chrisgrieser/nvim-various-textobjs',
  event = 'BufReadPost',
  opts = { useDefaultKeymaps = true },
  disabledKeymaps = { 'in', 'an' },
}
