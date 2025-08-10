return {
  "nvim-pack/nvim-spectre",
  lazy = true,
  cmd = "Spectre",
  opts = {
    mapping = {
      ['send_to_qf'] = {
        map = "q",
        cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
        desc = "send all items to quickfix"
      },
    },
  },
}
