return {
  'fedepujol/move.nvim',
  keys = {
    { '<C-j>', ':MoveBlock(1)<CR>',  mode = 'v', desc = 'Move block down', silent = true },
    { '<C-k>', ':MoveBlock(-1)<CR>', mode = 'v', desc = 'Move block up',   silent = true },
    -- Give C-j a useful action when there are no lines to move eg.
    -- Open file search etc
    -- Also C-h to add some useful action outside in keymaps.lua?
    -- Could also do for other things
    {
      '<C-j>',
      function()
        local line_count = vim.api.nvim_buf_line_count(0)
        -- When there are no lines to move, open fzfDir
        -- Or should netrw case do something else?
        if line_count <= 1 or vim.bo.filetype == "netrw" then
          require("fff").find_in_git_root()
          -- if it had no git root
          if vim.v.shell_error ~= 0 then
            require("fff").find_files()
          end
        else
          vim.cmd('MoveLine 1')
        end
      end,
      mode = 'n',
      desc = 'Move block down or fzfDir',
      silent = true
    },
    -- Give <C-k> a useful action when there are no lines to move eg.
    -- open terminal
    {
      '<C-k>',
      function()
        local line_count = vim.api.nvim_buf_line_count(0)
        -- When there are no lines to move, open fzfDir
        if line_count <= 1 then
          -- Open terminal
          vim.cmd('term')
          vim.cmd('startinsert')
        else
          vim.cmd('MoveLine -1')
        end
      end,
      mode = 'n',
      desc = 'Move block up',
      silent = true
    },
  },
  opts = {
    line = {
      enable = true, -- Enables line movement
      indent = true, -- Toggles indentation
    },
    block = {
      enable = true, -- Enables block movement
      indent = true, -- Toggles indentation
    },
    word = {
      enable = true, -- Enables word movement
    },
    char = {
      enable = true, -- Enables char movement
    },
  },
  -- Normal-mode commands
  -- vim.keymap.set('n', '<A-h>', ':MoveHChar(-1)<CR>', opts)
  -- vim.keymap.set('n', '<A-l>', ':MoveHChar(1)<CR>', opts)
  -- vim.keymap.set('n', '<leader>wf', ':MoveWord(1)<CR>', opts)
  -- vim.keymap.set('n', '<leader>wb', ':MoveWord(-1)<CR>', opts)
}
