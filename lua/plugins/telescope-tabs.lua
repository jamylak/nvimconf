return {
  'LukasPietzschmann/telescope-tabs',
  keys = {
    {
      '<leader>ts',
      function()
        require('telescope-tabs').list_tabs()
      end,
      { desc = 'List tabs' },
    },
  },
  config = function()
    require('telescope').load_extension 'telescope-tabs'
    require('telescope-tabs').setup {
      -- Your custom config :^)
    }
  end,
  dependencies = { 'nvim-telescope/telescope.nvim' },
}
