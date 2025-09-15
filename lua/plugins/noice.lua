return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    messages = {
      -- NOTE: If you enable messages, then the cmdline is enabled automatically.
      -- This is a current Neovim limitation.
      enabled = true,
    },
    cmdline = {
      view = "cmdline",
      -- enabled = false,
    },
    lsp = {
      progress = {
        enabled = false,
      }
    },
    -- https://github.com/folke/noice.nvim/blob/main/lua/noice/config/views.lua#L166
    views = {
      mini = {
        align = "message-left",
        position = {
          row = -1,
          -- col = "100%",
          col = 0,
        },
      }
    },
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    -- "rcarriga/nvim-notify",
  }
}
