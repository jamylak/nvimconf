return {
  "folke/snacks.nvim",
  keys = {
    {
      "<m-g>",
      function()
        Snacks.lazygit()
      end,
      desc = "Open LazyGit"
    },
    {
      "<c-g>",
      function()
        Snacks.lazygit()
      end,
      desc = "Open LazyGit"
    },
    {
      "<m-b>",
      function()
        Snacks.lazygit.log_file()
      end,
      desc = "Open LazyGit"
    },
    {
      "<leader>i",
      function()
        local utils = require 'utils'
        utils.toggleExplorer()
      end,
      desc = "Open LazyGit"
    },
    {
      "<leader>fi",
      function()
        local utils = require 'utils'
        utils.searchExplorer()
      end,
      desc = "Open LazyGit"
    },
  },
  opts = {
    image = {},
    input = {},
    picker = {
      sources = {
        explorer = {
          hidden = true,
          ignored = true,
          actions = {
            quickfix = function(picker)
              -- Remap this back to smart-splits for now
              vim.cmd("stopinsert")
              require('smart-splits').resize_left()
            end,
          },
          win = {
            input = {
              keys = {
                -- Just fixing up some common keybinds and conflicts
                -- a-h one is a bit buggy
                ["<a-h>"] = { "quickfix", mode = { "n", "i" } },
                ["<leader>h"] = { "toggle_hidden", mode = { "n" } },
                ["<a-.>"] = { "toggle_hidden", mode = { "n", "i" } },
                ["q"] = { "qflist", mode = { "n" } },
                ["H"] = {
                  require("utils").searchAcrossWindows,
                  mode = { "n" }
                },
              }
            },
            list = {
              keys = {
                ["<a-h>"] = { "quickfix", mode = { "n", "i" } },
                ["q"] = { "qflist", mode = { "n" } },
                ["<leader>h"] = { "toggle_hidden", mode = { "n" } },
                ["<a-.>"] = { "toggle_hidden", mode = { "n" } },
                ["H"] = {
                  require("utils").searchAcrossWindows,
                  mode = { "n" }
                },
              }
            }
          },
        },
      }
    }
  },
  -- Could just make this a dependency of eg. everything
  -- that should use it eg. molten instead of loading it
  -- VeryLazy
  event = "VeryLazy",
  -- lazy = false,
  cmd = { "LazyGit" },
  config = function(_, opts)
    if vim.g.neovide then
      -- disable image support in neovide for now
      -- as it doesn't yet work
      opts.image = nil
    end
    -- Make a user command to open lazygit
    vim.api.nvim_create_user_command("LazyGit", function()
      Snacks.lazygit()
      vim.schedule(function()
        vim.cmd("startinsert")
      end)
    end, { desc = "Open LazyGit" })
    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "*lazygit*",
      callback = function(args)
        -- For these keymaps, close lazy git then feed through the keys
        local keys = { "<a-i>", "<a-u>", "<a-y>", "<a-space>", "<a-o>", "<a-g>", "<a-n>", "<c-space>", "<a-;>" }
        for _, key in ipairs(keys) do
          vim.keymap.set("t", key, function()
            -- Quit Lazygit
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('q', true, false, true), "t", false)
            vim.schedule(function()
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "t", false)
            end)
          end, { buffer = args.buf, noremap = true, silent = true, desc = "Close lazygit and feed keys" })
        end
      end,
    })
    require("snacks").setup(opts)
  end,
}
