return {
  'zbirenbaum/copilot.lua',
  event = 'InsertCharPre',
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
        next = '<M-]>',
        prev = '<M-[>',
        dismiss = '<C-e>',
      },
    },
  },
}
