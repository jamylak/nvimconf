return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    cmd = {
      'CopilotChat',
      'CopilotChatOpen',
      'CopilotChatClose',
      'CopilotChatToggle',
      'CopilotChatReset',
      'CopilotChatSave',
      'CopilotChatLoad',
      'CopilotChatDebugInfo',
    },
    keys = {
      {
        '<leader><leader>C',
        function()
          local input = vim.fn.input 'Quick Chat: '
          if input ~= '' then
            require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
          end
        end,
        desc = 'CopilotChat - Quick chat',
      },
      {
        '<leader>C',
        mode = { 'n', 'v' },
        function()
          require('CopilotChat').open()
        end,
      },
    },
    branch = 'main',
    dependencies = {
      { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
      { 'nvim-lua/plenary.nvim' },  -- for curl, log wrapper
    },
    opts = {
      -- debug = true, -- Enable debugging
      mappings = {
        jump_to_diff = {
          -- todo: add back, just not gj
          normal = 'gD',
        },
        close = {
          insert = '<nop>',
        },
      },
    },
    config = function(_, opts)
      -- just to make it look nicer
      -- and cause i lazy load theme
      -- for no good reason
      require('tokyodark')
      require("CopilotChat").setup(opts)
    end,
    -- See Commands section for default commands if you want to lazy load on them
  },
}
