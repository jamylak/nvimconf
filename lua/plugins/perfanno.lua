return {
  "t-troebst/perfanno.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  cmd = {
    "PerfLoadFlat",
    "PerfLoadCallGraph",
    "PerfLoadFlameGraph",
    "PerfPickEvent",
    "PerfAnnotate",
    "PerfAnnotateFunction",
    "PerfAnnotateSelection",
    "PerfToggleAnnotations",
    "PerfHottestLines",
    "PerfHottestSymbols",
    "PerfHottestCallersFunction",
    "PerfHottestCallersSelection",
  },
  keys = {
    { "<leader>PA", "<cmd>PerfAnnotate<cr>",                desc = "Annotate buffer" },
    { "<leader>PB", "<cmd>PerfAnnotateFunction<cr>",        desc = "Annotate function" },
    { "<leader>PC", "<cmd>PerfAnnotateSelection<cr>",       mode = "v",                     desc = "Annotate selection" },

    { "<leader>PD", "<cmd>PerfLoadFlat<cr>",                desc = "Load flat profile" },
    { "<leader>PE", "<cmd>PerfLoadCallGraph<cr>",           desc = "Load call graph" },
    { "<leader>PF", "<cmd>PerfLoadFlameGraph<cr>",          desc = "Load flame graph" },

    { "<leader>PG", "<cmd>PerfPickEvent<cr>",               desc = "Pick event" },
    { "<leader>PH", "<cmd>PerfToggleAnnotations<cr>",       desc = "Toggle annotations" },

    { "<leader>PI", "<cmd>PerfHottestLines<cr>",            desc = "Hottest lines" },
    { "<leader>PJ", "<cmd>PerfHottestSymbols<cr>",          desc = "Hottest symbols" },
    { "<leader>PK", "<cmd>PerfHottestCallersFunction<cr>",  desc = "Hottest callers (func)" },
    { "<leader>PL", "<cmd>PerfHottestCallersSelection<cr>", mode = "v",                     desc = "Hottest callers (sel)" },
  },
  opts = {
    line_highlights = true,
    virt_text_pos = "right_align",
  }
}
