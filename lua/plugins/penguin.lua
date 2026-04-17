return {
  'jamylak/penguin.nvim',
  -- Uncomment for local development.
  -- dir = '/Users/james/proj/penguin.nvim',
  build = 'make native',
  cmd = 'Penguin',
  keys = {
    {
      '<M-Space>',
      function()
        pcall(vim.cmd, 'stopinsert')
        vim.schedule(function()
          require('penguin').open()
        end)
      end,
      desc = 'Open penguin.nvim',
      mode = 'i',
    },
    { '<M-Space>', '<cmd>Penguin<cr>', desc = 'Open penguin.nvim', mode = 'n' },
    { '<leader>:', '<cmd>Penguin<cr>', desc = 'Open penguin.nvim', mode = 'n' },
    { '<m-;>', '<cmd>Penguin<cr>', desc = 'Open penguin.nvim', mode = 'n' },
  },
  config = function()
    require('penguin').setup({
      open_on_bare_enter = true,
    })
  end,
}
