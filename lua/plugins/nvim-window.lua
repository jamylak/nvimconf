vim.keymap.set('i', 'gj', "<esc><cmd>lua require('nvim-window').pick()<cr>", { desc = 'nvim-window: Jump to window', silent = true })
vim.keymap.set('t', 'gj', "<C-\\><C-n><cmd>lua require('nvim-window').pick()<cr>", { desc = 'nvim-window: Jump to window', silent = true })

return {
  'jamylak/nvim-window',
  branch = 'feature/disable-hints',
  keys = {
    {
      'gj',
      function()
        require('nvim-window').pick()
        local buf_id = vim.api.nvim_get_current_buf()
        local buf_type = vim.api.nvim_buf_get_option(buf_id, 'buftype')
        if buf_type == 'terminal' then
          vim.cmd 'startinsert'
        end
      end,
      desc = 'nvim-window: Jump to window',
    },
  },
  config = function()
    require('nvim-window').setup {
      -- The characters available for hinting windows.
      chars = {
        'i',
        'o',
        ' ',
        'g',
        'j',
        'd',
        'e',
        'f',
        'h',
        'm',
        'n',
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
      disable_hint = false,
      disable_hint_if_less_than_n_windows = 3,
    }
  end,
}
