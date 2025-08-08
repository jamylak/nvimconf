return {
  "folke/snacks.nvim",
  keys = {
    {
      "<leader><a-g>",
      function()
        Snacks.lazygit()
      end,
      desc = "Open LazyGit"
    },
  },
}
