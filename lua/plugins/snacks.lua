return {
  "folke/snacks.nvim",
  keys = {
    {
      "<m-g>",
      function()
        Snacks.lazygit()
      end,
      desc = "Open LazyGit"
    },
    {
      "<m-b>",
      function()
        Snacks.lazygit.log_file()
      end,
      desc = "Open LazyGit"
    },
    {
      "<leader>gl",
      function()
        Snacks.lazygit.log_file()
      end,
      desc = "Open LazyGit"
    },
  },
}
