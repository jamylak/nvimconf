-- https://vi.stackexchange.com/questions/45283/how-can-i-get-lua-5-1-for-lazy-nvim-luarocks-on-macos
return {
  "rest-nvim/rest.nvim",
  ft = { "http", "rest" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    -- cmd = { "Rest" },
    -- cmd = { "Rest open",
    --   "Rest run",
    --   "Rest last",
    --   "Rest logs",
    --   "Rest cookies",
    --   "Rest env show",
    --   "Rest env select",
    --   "Rest env set", },
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "http")
    end,
  }
}
