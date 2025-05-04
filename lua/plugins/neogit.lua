return {
  'NeogitOrg/neogit',
  cmd = 'Neogit',
  -- I don't like how they changed the "dr"
  -- to not show the suggestion of eg. main..HEAD
  -- now it takes like 3 clicks to get there
  commit = '75ee709d18625a94aef90d94ccac4e562c9a0046',
  keys = {
    { '<leader>gn', ':Neogit<CR>' },
    {
      -- mode = { 'n', 'i' },
      '<c-g>',
      function()
        require('neogit').open()
      end,
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration
    'nvim-telescope/telescope.nvim',
  },
  config = true,
}
