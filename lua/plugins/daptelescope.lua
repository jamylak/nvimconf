return {
  "nvim-telescope/telescope-dap.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "mfussenegger/nvim-dap",
  },
  cmd = {
    "Telescope dap commands",
    "Telescope dap configurations",
    "Telescope dap list_breakpoints",
    "Telescope dap variables",
    "Telescope dap frames",
  },
  config = function()
    require("telescope").load_extension("dap")
  end,
}
