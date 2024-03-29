vim.keymap.set('i', 'gj', "<esc><cmd>lua require('nvim-window').pick()<cr>", { desc = 'nvim-window: Jump to window', silent = true })
vim.keymap.set('t', 'gj', "<esc><cmd>lua require('nvim-window').pick()<cr>", { desc = 'nvim-window: Jump to window', silent = true })

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
        'i',
        'o',
        'k',
        -- 'd', -- Or try l
        'l', -- Or try d
        'e',
        'f',
        'g',
        'h',
        'j',
        'm',
        'n',
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
