return {
  "scottmckendry/cyberdream.nvim",
  -- cond = function()
  --   return not vim.g.neovide
  -- end,
  -- event = { 'BufReadPost', 'BufWritePost' },
  event = "VeryLazy",
  priority = 100000,
  keys = {
    { "<leader>tt", ":CyberdreamToggleMode<CR>", desc = "Toggle Cyberdream Mode" },
  },
  config = function(_, opts)
    local orange = "#efbd5e"
    local black = "#000000"
    require("cyberdream").setup({
      transparent = true,
      -- Improve start up time by caching highlights. Generate cache with :CyberdreamBuildCache and clear with :CyberdreamClearCache
      -- Currently it's having issues
      cache = not vim.g.neovide,
      borderless_pickers = false,
      terminal_colors = false,
      highlights = {
        Visual = { bg = orange, fg = black },
        CursorLine = { bg = "#33334c" },
        -- CursorLine = { bg = "#4b337c" },
        -- Terminal = { fg = p.white, bg = p.white },
        -- StatusLineNC = { fg = p.white, bg = p.bg1, bold = true },
        -- Comment = { fg = "#b0b0b0", italic = true },
        -- Comment = { fg = "#ffd8a8", italic = true },
      },

    })
    -- vim.cmd [[ highlight Normal guifg=#000000 ]]

    vim.cmd.colorscheme "cyberdream"
  end,
}
