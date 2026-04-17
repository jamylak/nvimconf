return {
  'jamylak/penguin.nvim',
  -- Uncomment for local development.
  -- dir = '/Users/james/proj/penguin.nvim',
  build = 'make native',
  cmd = 'Penguin',
  init = function(plugin)
    vim.keymap.set('n', '<CR>', function()
      local filetype = vim.bo.filetype

      if vim.fn.getcmdwintype() ~= '' or vim.bo.buftype ~= '' then
        return '<CR>'
      end

      if filetype == 'help' or filetype == 'netrw' or filetype == 'qf' then
        return '<CR>'
      end

      require('lazy').load { plugins = { plugin.name } }
      return require('penguin').handle_bare_enter()
    end, {
      desc = 'Open penguin.nvim on bare Enter',
      expr = true,
      silent = true,
    })
  end,
  keys = {
    {
      '<M-Space>',
      function()
        pcall(vim.cmd, 'stopinsert')
        vim.schedule(function()
          require('penguin').open()
        end)
      end,
      desc = 'Open penguin.nvim',
      mode = 'i',
    },
    { '<M-Space>', '<cmd>Penguin<cr>', desc = 'Open penguin.nvim', mode = 'n' },
    { '<leader>:', '<cmd>Penguin<cr>', desc = 'Open penguin.nvim', mode = 'n' },
    { '<m-;>', '<cmd>Penguin<cr>', desc = 'Open penguin.nvim', mode = 'n' },
  },
  config = function()
    require('penguin').setup {
      open_on_bare_enter = true,
    }
  end,
}
