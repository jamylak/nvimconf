local function troubleInCurTab()
  return vim.tbl_contains(
    vim.tbl_map(function(w)
      return vim.fn.getbufvar(vim.api.nvim_win_get_buf(w), '&filetype')
    end, vim.api.nvim_tabpage_list_wins(0)),
    'trouble'
  )
end
return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = { 'Trouble' },
  keys = {
    {
      '<leader>xx',
      '<cmd>Trouble diagnostics open new=true<cr>',
      desc = 'Diagnostics (Trouble)',
    },
    {
      '<leader>xX',
      function()
        if troubleInCurTab() then
          -- Close only for current tab
          vim.cmd 'Trouble close'
        else
          vim.cmd 'Trouble diagnostics open new=true filter.buf=0'
        end
      end,
      desc = 'Buffer Diagnostics (Trouble)',
    },
    {
      '<leader>xs',
      function()
        if troubleInCurTab() then
          -- Close only for current tab
          vim.cmd 'Trouble close'
        else
          vim.cmd 'Trouble symbols open new=true focus=false'
        end
      end,
      '<cmd>Trouble symbols open new=true focus=false<cr>',
      desc = 'Symbols (Trouble)',
    },
    {
      '<leader>xl',
      '<cmd>Trouble lsp open new=true focus=false win.position=right<cr>',
      desc = 'LSP Definitions / references / ... (Trouble)',
    },
    {
      '<leader>xL',
      '<cmd>Trouble loclist open new=true<cr>',
      desc = 'Location List (Trouble)',
    },
    {
      '<leader>xQ',
      '<cmd>Trouble qflist open new=true<cr>',
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
