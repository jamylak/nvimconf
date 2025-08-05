-- https://github.com/nvim-neotest/neotest
-- https://www.lazyvim.org/extras/test/core
-- TODO: Should it get the DAP ready?
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python"
  },
  opts = {
    -- General options
    status = { virtual_text = true },
    output = {
      open_on_run = true, -- Automatically open output panel when running tests
    },
    -- TO test
    -- quickfix = {
    --   enabled = true,
    --   open = function()
    --     require("trouble").open({ mode = "quickfix", focus = false })
    --     -- vim.cmd("copen")
    --   end
    -- },
  },
  keys = {
    -- Core test runners
    { "<leader>NN", function() require("neotest").run.run() end,                   desc = "Run Nearest Test" },
    { "<leader>NF", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File Tests" },
    {
      "<leader>NP",
      function()
        -- TODO: Check correct path
        local git_root = require("utils").get_git_root(vim.fn.expand("%:p"))
        require("neotest").run.run(git_root)
        require("neotest").summary.open()
      end,
      desc = "Run Project Tests",
    },
    {
      "<leader>NJ",
      function()
        -- TODO: Check correct path
        local git_root = require("utils").get_git_root(vim.fn.expand("%:p"))
        require("neotest").run.run(git_root)
        require("neotest").summary.open()
      end,
      desc = "Run Project Tests",
    },
    {
      "<leader>ND",
      function()
        local dapui = require("dapui")
        dapui.open()
        require("neotest").run.run({ strategy = "dap" })
      end,
      desc = "Debug Nearest Test"
    },

    -- Output + Summary
    { "<leader>NO", function() require("neotest").output.open({ enter = true }) end,    desc = "Open Test Output" },
    { "<leader>NS", function() require("neotest").summary.toggle() end,                 desc = "Toggle Summary Tree" },
    { "<leader>NT", function() require("neotest").output_panel.toggle() end,            desc = "Toggle Output Panel" },
    { "<leader>NC", function() require("neotest").output_panel.clear() end,             desc = "Clear Output Panel" },

    -- Bonus
    { "<leader>NX", function() require("neotest").run.stop() end,                       desc = "Stop Running Tests" },
    { "<leader>NL", function() require("neotest").jump.next({ status = "failed" }) end, desc = "Jump to Next Failed Test" },
    { "<leader>NH", function() require("neotest").jump.prev({ status = "failed" }) end, desc = "Jump to Prev Failed Test" },
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-python"),
      },
    })
  end,
}
