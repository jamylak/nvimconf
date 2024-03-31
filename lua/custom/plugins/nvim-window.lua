vim.keymap.set('i', 'gj', "<esc><cmd>lua require('nvim-window').pick()<cr>", { desc = 'nvim-window: Jump to window', silent = true })
vim.keymap.set('t', 'gj', "<C-\\><C-n><cmd>lua require('nvim-window').pick()<cr>", { desc = 'nvim-window: Jump to window', silent = true })

return {
  'jamylak/nvim-window',
  branch = 'feature/after-jump-callback',
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
      after_jump_callback = function(window)
        local buf_id = vim.api.nvim_win_get_buf(window)
        local buf_type = vim.api.nvim_buf_get_option(buf_id, 'buftype')
        if buf_type == 'terminal' then
          vim.cmd 'startinsert'
        end
      end,
    }
  end,
}
