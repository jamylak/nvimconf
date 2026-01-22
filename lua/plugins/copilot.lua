return {
  'zbirenbaum/copilot.lua',
  -- Note: There is currently an issue eg.
  -- Open project in working dir of eg. ~/foo
  -- and then start :new, :w /tmp/gloo.txt
  -- And now it will give error
  -- [Copilot.lua] RPC[Error] code_name = InvalidParams, message = "Document for URI could not be found: file:///private/tmp/gloo.lua"
  -- But if you do :e it fixes it...
  -- Quickfix for https://github.com/tonisives/ovim/issues/19 for now
  enabled = vim.env.SHELL ~= "/bin/zsh",
  -- Defer startup cost until you actually start typing.
  event = 'InsertEnter',
  cmd = 'Copilot',
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      debounce = 75,
      keymap = {
        accept = '<S-CR>',
        accept_word = false,
        accept_line = false,
        next = '<M-S-]>',
        prev = '<M-S-[>',
        dismiss = '<C-space>',
      },
    },
  },
}
