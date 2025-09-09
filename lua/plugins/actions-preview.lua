return {
  'aznhe21/actions-preview.nvim',
  keys = {

    {
      '<leader>la',
      function()
        require('actions-preview').code_actions()
      end,
    },
  },
  -- Quickfix for:
  -- Unsupported layout_config key for the horizontal strategy: preview_width
  -- use horizontal to not interfere with telescope default for
  -- preview_width
  opts = {
    telescope = {
      sorting_strategy = "ascending",
      layout_strategy = "horizontal",
      layout_config = {
        width = 0.8,
        height = 0.9,
        prompt_position = "top",
        preview_cutoff = 20,
      },
    },
  },
}
