return {
  "scottmckendry/cyberdream.nvim",
  -- lazy = false,
  -- priority = 1000,
  event = { 'BufReadPost', 'BufWritePost' },
  config = function(_, opts)
    local p = require("cyberdream.colors")
    -- local orange = "#ffbd5e"
    local orange = "#efbd5e"
    require("cyberdream").setup({
      transparent = true,
      highlights = {
        -- Terminal = { fg = p.white, bg = p.white },
        Visual = { bg = orange, fg = p.black },
        -- StatusLineNC = { fg = p.white, bg = p.bg1, bold = true },
        -- Comment = { fg = "#b0b0b0", italic = true },
        -- Comment = { fg = "#ffd8a8", italic = true },
      },

    })
    vim.cmd [[ highlight Normal guifg=#FFFFFF ]]

    vim.cmd.colorscheme "cyberdream"
  end,
}
