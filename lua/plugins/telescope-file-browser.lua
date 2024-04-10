local function openTSFB()
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
end
return {
  'nvim-telescope/telescope-file-browser.nvim',
  keys = {
    { '<leader>fi', openTSFB },
  },
  dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
}
