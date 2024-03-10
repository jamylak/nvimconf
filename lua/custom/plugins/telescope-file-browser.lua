vim.api.nvim_set_keymap('n', '<leader>b', ':Telescope file_browser path=%:p:h select_buffer=true<CR>', { noremap = true })
-- vim.api.nvim_set_keymap('n', '<leader>fi', ':Telescope file_browser path=%:p:h select_buffer=true<CR>', { noremap = true })

vim.keymap.set('n', '<leader>fi', function()
  local path = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  -- If path starts with oil:// then get the part after
  if string.match(path, '^oil://') then
    path = string.sub(path, 7)
  else
    path = vim.fn.expand '%:p:h'
  end
  require('telescope').extensions.file_browser.file_browser {
    path = path,
    select_buffer = true,
  }
end, { noremap = true })
-- vim.api.nvim_set_keymap('n', '<leader>fb', ':Telescope file_browser path=' .. os.getenv 'PROJECTS_DIR' .. 'select_buffer=true<CR>', { noremap = true })
return {
  'nvim-telescope/telescope-file-browser.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
}
