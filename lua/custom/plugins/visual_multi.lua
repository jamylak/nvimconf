-- Not playing well with lua snips eg. CTRL-Y not working
vim.g.VM_leader = '=' -- sets vim.g.VM_leader for visual multi
return {
  'mg979/vim-visual-multi',
  branch = 'master',
  keys = {
    { '<C-n>', '<Plug>(VM-Find-Word)' },
    { '<A-Down>', '<Plug>(VM-Select-Cursor-Down)' },
    { '<A-Up>', '<Plug>(VM-Select-Cursor-Up)' },
  },
}
