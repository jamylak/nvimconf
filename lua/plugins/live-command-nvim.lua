local utils = require 'utils'
return {
  'smjonas/live-command.nvim',
  ft = utils.sourceFileTypes,
  -- Norm doesn't seem to work well
  config = function()
    require('live-command').setup {
      commands = {
        Norm = { cmd = 'norm' },
        G = { cmd = 'g' },
      },
    }
  end,
}
