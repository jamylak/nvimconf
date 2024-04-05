return {
  'nvim-telescope/telescope-undo.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  cmd = 'Telescope undo',
  keys = {
    { '<leader>fu', '<cmd>Telescope undo<cr>', desc = '[F]ind [U]ndo' },
  },
  config = function()
    require('telescope').load_extension 'undo'
    -- optional: vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")
  end,
}
