-- TODO: move in config or something
-- FFF.nvim and Telescope swap through each other
-- when needed with some keybindings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "fff_input",
  callback = function(args)
    vim.keymap.set("i", "<m-i>", function()
      vim.cmd "stopinsert"
      require("fff.picker_ui").close()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<A-i>", true, false, true), "m", false)
    end, { buffer = args.buf, noremap = true, silent = true, desc = "Close FFF and feed <m-i>" })
  end,
})
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
        -- if it had no git root
        if vim.v.shell_error ~= 0 then
          require("fff").find_files()
        end
      end,
      desc = "Open file picker",
    },
    {
      "<c-space>",
      function()
        require("fff").find_in_git_root()
        -- if it had no git root
        if vim.v.shell_error ~= 0 then
          require("fff").find_files()
        end
      end,
      desc = "Open file picker",
    },
  },
}
