return {
  'jonarrien/telescope-cmdline.nvim',
  dependencies = {},
  cmd = 'Telescope cmdline',
  keys = {
    { '<m-space>', '<cmd>Telescope cmdline<cr>', desc = 'Telescope cmdline', mode = 'n' },
    { '<m-space>', '<cmd>Telescope cmdline<cr>', desc = 'Telescope cmdline', mode = 'i' },
  },
  config = function()
    -- TODO: Override C-j to do <enter>
    require('telescope').load_extension 'cmdline'
    require('telescope._extensions.cmdline').setup {
      picker = {
        layout_config = {
          width = 120,
          height = 25,
        },
      },
    }
  end,
}
