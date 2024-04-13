-- Not currently working
return {
  'jghauser/kitty-runner.nvim',
  config = function()
    local opts = require('kitty-runner.config').window_config
    require('kitty-runner').setup(opts)
  end,
  cmd = {
    'KittyOpenRunner',
    'KittySendLines',
    'KittyRunCommand',
    'KittyReRunCommand',
    'KittyClearRunner',
    'KittyKillRunner',
  },
}
