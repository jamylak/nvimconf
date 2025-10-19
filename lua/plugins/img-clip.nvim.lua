return {
  "HakonHarnes/img-clip.nvim",
  ft = { "markdown", "norg", "text" },
  -- event = "VeryLazy",
  opts = {
    default = {
      insert_mode_after_paste = false,
    },
    filetypes = {
      markdown = {
        template = "![$FILE_NAME$CURSOR]($FILE_PATH)",
      },
    },
  },
  keys = {
    -- suggested keymap
    {
      "<leader>p",
      function()
        require("img-clip").paste_image()
      end,
      desc = "Paste image from system clipboard"
    },
    {
      "<leader>P",
      function()
        Snacks.picker.files {
          ft = { "jpg", "jpeg", "png", "webp" },
          confirm = function(self, item, _)
            self:close()
            -- ./ is necessary for img-clip to recognize it as path
            require("img-clip").paste_image({}, "./" .. item.file)
          end,
        }
      end,
      desc = "Paste from snacks"
    },
  },
  cmd = { "PasteImage", "ImgClipDebug", "ImgClipConfig" },
}
