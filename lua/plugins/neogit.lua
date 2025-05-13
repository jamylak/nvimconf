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
      '<c-g>',
      function()
        -- Open neogit in a new tab
        -- but behind current tab so when it is
        -- closed it goes back to the previous tab
        vim.cmd 'tabnew'
        vim.cmd 'tabmove -1'
        require('neogit').open { kind = 'replace' }
      end,
    },
    {
      '<leader>gv',
      function()
        require('neogit').open { kind = 'vsplit' }
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
