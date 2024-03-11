vim.keymap.set('i', 'wj', "<esc><cmd>lua require('nvim-window').pick()<cr>", { desc = 'nvim-window: Jump to window' })
vim.keymap.set('t', 'wj', "<esc><cmd>lua require('nvim-window').pick()<cr>", { desc = 'nvim-window: Jump to window' })
return {
  'yorickpeterse/nvim-window',
  keys = {
    { '<leader>wj', "<cmd>lua require('nvim-window').pick()<cr>", desc = 'nvim-window: Jump to window' },
  },
  config = true,
}
