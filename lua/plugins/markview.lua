return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "OXY2DEV/markview.nvim" },
  cmd = { "Markview" },
  -- Apparently it is lazy by default
  lazy = false,
  opts = {
    latex = {
      enable = true,
    }
  },
  priority = 49,
}
