return {
  'tiagovla/tokyodark.nvim',
  -- cond = function()
  --   return vim.g.neovide
  -- end,
  -- lazy = false, -- make sure we load this during startup if it is your main colorscheme
  event = { 'BufReadPost', 'BufWritePost' },
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    local p = require 'tokyodark.palette'
    require('tokyodark').setup {
      styles = {
        comments = { italic = true },
        keywords = { italic = false },
        identifiers = { italic = false },
        functions = {},
        variables = {},
      },
      custom_highlights = {
        Terminal = { fg = p.white, bg = p.white },
        Visual = { bg = p.yellow, fg = p.black },
        StatusLineNC = { fg = p.white, bg = p.bg1, bold = true },
        Comment = { fg = "#b0b0b0", italic = true },
      },
      transparent_background = true,
      -- terminal_colors = false,
    }
    -- vim.g.terminal_color_0 =
    vim.cmd.colorscheme 'tokyodark'
    -- vim.cmd [[ guifg=#FFFFFF ]]
    vim.cmd [[ highlight Normal guifg=#FFFFFF ]]

    -- You can configure highlights by doing something like
    vim.cmd.hi 'Comment gui=none'
  end,
}
