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
      "<m-b>",
      function()
        Snacks.lazygit.log_file()
      end,
      desc = "Open LazyGit"
    },
  },
  config = function()
    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "*lazygit*",
      callback = function(args)
        -- For these keymaps, close lazy git then feed through the keys
        local keys = { "<a-i>", "<a-u>", "<a-y>", "<a-space>", "<a-o>", "<a-g>", "<a-n>", "<c-space>", "<a-;>" }
        for _, key in ipairs(keys) do
          vim.keymap.set("t", key, function()
            -- Quit neovim
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('q', true, false, true), "t", false)
            vim.schedule(function()
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "t", false)
            end)
          end, { buffer = args.buf, noremap = true, silent = true, desc = "Close lazygit and feed keys" })
        end
      end,
    })
    require("snacks").setup({
    })
  end,
}
