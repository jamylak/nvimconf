return {
  'jvgrootveld/telescope-zoxide',
  cmd = 'Telescope zoxide list',
  keys = {
    {
      '<leader>z',
      function()
        require('telescope').extensions.zoxide.list {
          mappings = {
            default = {
              after_action = function(selection)
                -- Not workin TODO: Open oil there after
                print('UPD to (' .. selection.z_score .. ') ' .. selection.path)
              end,
            },
          },
        }
      end,
      { desc = 'List zoxide' },
    },
  },
}
