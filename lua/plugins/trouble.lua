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

-- https://github.com/folke/trouble.nvim/blob/dev/docs/examples.md#open-trouble-quickfix-when-the-qf-list-opens
vim.api.nvim_create_autocmd("BufRead", {
  callback = function(ev)
    if vim.bo[ev.buf].buftype == "quickfix" then
      vim.schedule(function()
        vim.cmd([[cclose]])
        -- Hacky Quickfix to close it where it was before
        vim.cmd([[Trouble qflist close]])
        vim.cmd([[Trouble qflist open]])
      end)
    end
  end,
})

-- Doesn't seem to be a way to override the CCLOSE nicely
vim.api.nvim_create_user_command("CCLOSE", function()
  vim.cmd([[Trouble qflist close]])
end, {})
vim.api.nvim_create_user_command("COPEN", function()
  -- vim.cmd([[Trouble qflist open new=true focus=true]])
  vim.cmd([[Trouble qflist open focus=true]])
end, {})
vim.api.nvim_create_user_command("QCLOSE", function()
  vim.cmd([[Trouble qflist close]])
end, {})
vim.api.nvim_create_user_command("QFCLOSE", function()
  vim.cmd([[Trouble qflist close]])
end, {})
vim.api.nvim_create_user_command("QOPEN", function()
  vim.cmd([[Trouble qflist open focus=true]])
end, {})
vim.api.nvim_create_user_command("QFOPEN", function()
  vim.cmd([[Trouble qflist open focus=true]])
end, {})


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
