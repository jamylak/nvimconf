return {
  "dmtrKovalenko/fff.nvim",
  build = "cargo build --release",
  cmd = {
    "FFF",
    "FFFFind",
    "FFFScan",
    "FFFRefreshGit",
    "FFFClearCache",
    "FFFHealth",
    "FFFDebug",
    "FFFOpenLog",
  },
  -- or if you are using nixos
  -- build = "nix run .#release",
  opts = {
    -- pass here all the options
    keymaps = {
      close = { '<Esc>', '<C-c>' },
      select = { '<CR>', '<C-j>', '<C-m>' },
    }

  },
  keys = {
    {
      "<leader>F",
      function()
        require("fff").find_in_git_root()
      end,
      desc = "Open file picker",
    },
    {
      "<c-space>",
      function()
        require("fff").find_in_git_root()
      end,
      desc = "Open file picker",
    },
  },
}
