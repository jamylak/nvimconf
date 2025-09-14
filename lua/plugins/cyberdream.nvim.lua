return {
  "scottmckendry/cyberdream.nvim",
  -- event = { 'BufReadPost', 'BufWritePost' },
  event = "VeryLazy",
  priority = 1000,
  config = function(_, opts)
    local orange = "#efbd5e"
    local black = "#000000"
    require("cyberdream").setup({
      transparent = true,
      -- Improve start up time by caching highlights. Generate cache with :CyberdreamBuildCache and clear with :CyberdreamClearCache
      -- Currently it's having issues
      cache = true,
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
