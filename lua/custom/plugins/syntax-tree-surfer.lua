return {
  'ziontee113/syntax-tree-surfer',
  keys = {
    -- Normal mode Swapping
    {
      'vU',
      function()
        vim.opt.opfunc = 'v:lua.STSSwapUpNormal_Dot'
        return 'g@l'
      end,
      noremap = true,
      expr = true,
    },
    {
      'vD',
      function()
        vim.opt.opfunc = 'v:lua.STSSwapDownNormal_Dot'
        return 'g@l'
      end,
      noremap = true,
      expr = true,
    },
    {
      'vd',
      function()
        vim.opt.opfunc = 'v:lua.STSSwapCurrentNodeNextNormal_Dot'
        return 'g@l'
      end,
      noremap = true,
      expr = true,
    },
    {
      'vu',
      function()
        vim.opt.opfunc = 'v:lua.STSSwapCurrentNodePrevNormal_Dot'
        return 'g@l'
      end,
      noremap = true,
      expr = true,
    },
    -- Visual Selection from Normal Mode
    { 'vx', '<cmd>STSSelectMasterNode<cr>', noremap = true, silent = true },
    { 'vn', '<cmd>STSSelectCurrentNode<cr>', noremap = true, silent = true },
    -- Select nodes in visual mode
    { 'J', '<cmd>STSSelectNextSiblingNode<cr>', mode = 'x', noremap = true, silent = true },
    { 'K', '<cmd>STSSelectPrevSiblingNode<cr>', mode = 'x', noremap = true, silent = true },
    { 'H', '<cmd>STSSelectParentNode<cr>', mode = 'x', noremap = true, silent = true },
    { 'L', '<cmd>STSSelectChildNode<cr>', mode = 'x', noremap = true, silent = true },
    -- Swapping nodes in visual mode
    { '<A-j>', '<cmd>STSSwapNextVisual<cr>', mode = 'x', noremap = true, silent = true },
    { '<A-k>', '<cmd>STSSwapPrevVisual<cr>', mode = 'x', noremap = true, silent = true },
  },
  opts = {},
}
