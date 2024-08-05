return {
  'folke/which-key.nvim',
  keys = { '<leader>', 'a', 'c', 'g', 'h', 'l', 'n', 'o', 'p', 'q', 'r', 's', 'u', 'v', 'x', 'y', 'z', ']', '[', '=' },
  config = function()
    require('which-key').setup {}
    require('which-key').add {
      { '<leader>c', group = '[C]ode' },
      { '<leader>d', group = '[D]ocument' },
      { '<leader>r', group = '[R]ename' },
      { '<leader>f', group = '[F]ind' },
      { '<leader>s', group = '[S]earch' },
    }
  end,
}
