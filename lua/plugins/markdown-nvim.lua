return {
  'MeanderingProgrammer/markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  cmd = 'RenderMarkdownToggle',
  opts = {},
  keys = {
    {
      '<leader>rm',
      '<cmd>RenderMarkdownToggle<cr>',
      'n',
      'md',
    },
  },
}
