return {
  'aznhe21/actions-preview.nvim',
  keys = {

    {
      '<leader>la',
      function()
        require('actions-preview').code_actions()
      end,
    },
  },
}
