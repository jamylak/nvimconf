-- vim.keymap.set('n', '<leader>o', function()
--   local winid = vim.api.nvim_get_current_win()
--   local bufname = vim.api.nvim_buf_get_name(0)
--   local pardir = vim.fn.fnamemodify(bufname, ':h')
--   print('win id: ' .. winid .. ' bufname: ' .. bufname)
--
--   require('oil').open(pardir)
-- end, { desc = 'Open [O]il' })
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
return {
  'stevearc/oil.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    default_file_explorer = true,
    columns = {
      'icon',
      'permissions',
      'size',
      'mtime',
    },
    keymaps = {
      ['cd'] = 'actions.cd',
    },
  },
}
