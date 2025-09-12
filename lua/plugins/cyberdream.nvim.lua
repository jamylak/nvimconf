return {
  "scottmckendry/cyberdream.nvim",
  -- lazy = false,
  -- priority = 1000,
  event = { 'BufReadPost', 'BufWritePost' },
  config = function(_, opts)
    local p = require("cyberdream.colors")
    local orange = "#efbd5e"
    local black = "#000000"
    require("cyberdream").setup({
      transparent = true,
      -- Improve start up time by caching highlights. Generate cache with :CyberdreamBuildCache and clear with :CyberdreamClearCache
      -- cache = true,
      highlights = {
        Visual = { bg = orange, fg = black },
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
