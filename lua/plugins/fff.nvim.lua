return {
  "dmtrKovalenko/fff.nvim",
  build = "cargo build --release",
  -- or if you are using nixos
  -- build = "nix run .#release",
  opts = {
    -- pass here all the options
  },
  keys = {
    {
      "<leader>F",
      function()
        require("fff").find_in_git_root()
      end,
      desc = "Open file picker",
    },
  },
}
