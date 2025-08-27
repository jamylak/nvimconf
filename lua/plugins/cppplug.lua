-- TODO: Fix issue inside plug eg. if i run CMakeNewProject
-- directly from CMakeLists.txt
return {
  {
    -- load from local directory sitting inside your config
    dir = vim.fn.stdpath("config") .. "/lua/cppplug",
    name = "cppplug",
    lazy = true,
    -- lazy = false,
    cmd = {
      "CMakeListsTxtGenCPP",
      "CMakeListsTxtGenC",
      "CMakeListsTxtGen",
      "CMakeNewProject",
      "CMakeConfigure",
      "CMakeBuildWatch",
      "CMakeBuildAndRunWatch",
      "CMakeBuildWatchUntilSuccess",
      "CMakeBuildOnce",
      "CMakeBuildOnceDebug",
    },
    -- keys = { { "<leader>mh", function() require("cppplug").echo() end, desc = "My hello" } },
    opts = {},
    config = function(_, opts)
      require("cppplug").setup(opts)
    end,
  },
}
