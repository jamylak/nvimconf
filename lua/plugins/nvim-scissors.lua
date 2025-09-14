local conf_dir = vim.fn.stdpath("config")
local snippets_dir = conf_dir .. "/lua/snippets"

return {
  "chrisgrieser/nvim-scissors",
  dependencies = "nvim-telescope/telescope.nvim",
  opts = {
    editSnippetPopup = {
      keymaps = {
        duplicateSnippet = "<leader>d",
      },
    },
    snippetDir = snippets_dir,
  },
  cmd = { "ScissorsAddNewSnippet", "ScissorsEditSnippet" },
  keys = {
    {
      "<leader>se",
      function() require("scissors").editSnippet() end,
      desc = "[S]nippet - [E]dit"
    },
    {
      "<leader>sa",
      function() require("scissors").addNewSnippet() end,
      desc = "[S]nippet - [A]dd"
    },
    {
      "<leader>sa",
      function() require("scissors").addNewSnippet() end,
      desc = "[S]nippet - [A]dd",
      mode = "x",
    },
  },
}
