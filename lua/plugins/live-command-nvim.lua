return {
  'smjonas/live-command.nvim',
  event = 'VeryLazy',
  -- If i don't put config it says the command has changed
  config = function()
    require('live-command').setup {
      commands = {
        Norm = { cmd = 'norm' },
        G = { cmd = 'g' },
      },
    }
  end,
}
