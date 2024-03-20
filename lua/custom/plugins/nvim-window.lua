vim.keymap.set('i', 'gj', "<esc><cmd>lua require('nvim-window').pick()<cr>", { desc = 'nvim-window: Jump to window', silent = true })
vim.keymap.set('t', 'gj', "<esc><cmd>lua require('nvim-window').pick()<cr>", { desc = 'nvim-window: Jump to window', silent = true })
-- vim.keymap.set('i', 'wj', "<esc><cmd>lua require('nvim-window').pick()<cr>", { desc = 'nvim-window: Jump to window' })
-- vim.keymap.set('t', 'wj', "<esc><cmd>lua require('nvim-window').pick()<cr>", { desc = 'nvim-window: Jump to window' })
return {
  'yorickpeterse/nvim-window',
  keys = {
    -- { '<leader>wj', "<cmd>lua require('nvim-window').pick()<cr>", desc = 'nvim-window: Jump to window' },
    { 'gj', "<cmd>lua require('nvim-window').pick()<cr>", desc = 'nvim-window: Jump to window' },
  },
  config = function()
    require('nvim-window').setup {
      -- The characters available for hinting windows.
      chars = {
        'a',
        's',
        'd',
        'e',
        'f',
        'g',
        'h',
        'i',
        'j',
        'k',
        'l',
        'm',
        'n',
        'o',
        'p',
        'q',
        'r',
        't',
        'u',
        'v',
        'w',
        'x',
        'y',
        'z',
      },
    }
  end,
}
