vim.api.nvim_set_keymap('n', '<space>b', ':Telescope file_browser path=%:p:h select_buffer=true<CR>', { noremap = true })
-- vim.api.nvim_set_keymap('n', '<space>fb', ':Telescope file_browser path=' .. os.getenv 'PROJECTS_DIR' .. 'select_buffer=true<CR>', { noremap = true })
return {
  'nvim-telescope/telescope-file-browser.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
}
