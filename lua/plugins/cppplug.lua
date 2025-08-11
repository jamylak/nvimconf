return {
  {
    -- load from local directory sitting inside your config
    dir = vim.fn.stdpath("config") .. "/lua/cppplug",
    name = "myplugin",
    lazy = false,
    -- lazy-load examples (optional):
    -- cmd = {
    --   "CMakeListsTxtGenCPP", "CMakeListsTxtGenC"
    -- },
    -- keys = { { "<leader>mh", function() require("cppplug").echo() end, desc = "My hello" } },
    opts = {},
    config = function(_, opts)
      require("cppplug").setup(opts)
    end,
  },
}
