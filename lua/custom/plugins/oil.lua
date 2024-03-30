local function tabChangeDirectory()
  local path = vim.fn.expand '%:p'
  -- If path starts with oil:// then get the part after
  if string.match(path, '^oil://') then
    path = string.sub(path, 7)
  else
    path = vim.fn.expand '%:p:h'
  end
  local dir_path = vim.fn.fnamemodify(path, ':h')
  vim.cmd('tcd ' .. dir_path)
end

return {
  'stevearc/oil.nvim',
  lazy = false,
  cmd = { 'Oil' },
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    { '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' } },
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
      ['<leader>tc'] = {
        callback = tabChangeDirectory,
        desc = '[T]ab [C]hange [D]irectory',
        mode = 'n',
      },
      ['tcd'] = {
        callback = tabChangeDirectory,
        desc = '[T]ab [C]hange [D]irectory',
        mode = 'n',
      },
    },
  },
}
