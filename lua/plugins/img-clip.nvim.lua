return {
  "HakonHarnes/img-clip.nvim",
  ft = { "markdown", "norg", "text" },
  -- event = "VeryLazy",
  opts = {
    -- add options here
    -- or leave it empty to use the default settings
  },
  keys = {
    -- suggested keymap
    { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    {
      "<leader>P",
      function()
        Snacks.picker.files {
          ft = { "jpg", "jpeg", "png", "webp" },
          confirm = function(self, item, _)
            self:close()
            require("img-clip").paste_image({}, "./" .. item.file) -- ./ is necessary for img-clip to recognize it as path
          end,
        }
      end,
      desc = "Paste from snacks"
    },
  },
  cmd = { "PasteImage", "ImgClipDebug", "ImgClipConfig" },
}
