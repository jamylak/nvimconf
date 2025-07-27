return {
  'zbirenbaum/copilot.lua',
  event = 'BufReadPost',
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
