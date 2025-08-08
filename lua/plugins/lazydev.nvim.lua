return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "snacks.nvim",        words = { "Snacks" } },
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {             -- optional cmp completion source for require statements and module annotations
    "hrsh7th/nvim-cmp",
    ft = "lua", -- only load on lua files
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
  }
}
