local function troubleInCurTab()
  return vim.tbl_contains(
    vim.tbl_map(function(w)
      return vim.fn.getbufvar(vim.api.nvim_win_get_buf(w), '&filetype')
    end, vim.api.nvim_tabpage_list_wins(0)),
    'trouble'
  )
end
local function troublePreset1()
  if troubleInCurTab() then
    -- Close only for current tab
    vim.cmd 'Trouble close'
    vim.cmd 'Trouble close'
  else
    vim.cmd 'Trouble symbols open new=true focus=false'
    vim.cmd 'Trouble lsp open new=true focus=false win.position=bottom'
    -- vim.cmd 'Trouble diagnostics open new=true filter.buf=0'
  end
end
local function troubleAndNeotree()
  local utils = require 'utils'
  utils.neotreeToggle()
  troublePreset1()
end
return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = { 'Trouble' },
  keys = {
    {
      '<leader>xj',
      troubleAndNeotree,
      desc = 'Trouble and Neotree',
    },
    {
      '<leader>,',
      troubleAndNeotree,
      desc = 'Trouble and Neotree',
    },
    {
      '<leader>b',
      troubleAndNeotree,
      desc = 'Trouble and Neotree',
    },
    {
      '<leader>xk',
      troublePreset1,
      desc = 'Trouble preset',
    },
    {
      '<leader>xx',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Diagnostics (Trouble)',
    },
    {
      '<leader>xX',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = 'Buffer Diagnostics (Trouble)',
    },
    {
      '<leader>xs',
      '<cmd>Trouble symbols toggle focus=false<cr>',
      desc = 'Symbols (Trouble)',
    },
    {
      '<leader>xl',
      '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
      desc = 'LSP Definitions / references / ... (Trouble)',
    },
    {
      '<leader>xL',
      '<cmd>Trouble loclist toggle<cr>',
      desc = 'Location List (Trouble)',
    },
    {
      '<leader>xQ',
      '<cmd>Trouble qflist toggle<cr>',
      desc = 'Quickfix List (Trouble)',
    },
  },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    warn_no_results = false,
    open_no_results = true,
    -- pinned = true,
  },
}
