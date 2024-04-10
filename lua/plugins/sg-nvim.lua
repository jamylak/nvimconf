return {
  {
    'sourcegraph/sg.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim', --[[ "nvim-telescope/telescope.nvim ]]
    },
    opts = {
      enable_cody = false,
    },
    keys = {
      { '<leader>sh', '<cmd>lua require("sg.extensions.telescope").fuzzy_search_results()<CR>' },
    },
  },
}
