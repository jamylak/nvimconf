-- TODO: Fix for FFFFind not going to insert when run from telescope cmd, seems it just needs a vim.schedule? or i find telescopecmd?
-- TODO: move in config or something
-- FFF.nvim and Telescope swap through each other
-- when needed with some keybindings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "fff_input",
  callback = function(args)
    -- Feed through these to telescope
    local keys = { "<a-i>", "<a-u>", "<a-y>", "<a-space>", "<a-o>", "<a-g>", "<a-n>", "<c-g>", "<a-;>" }
    for _, key in ipairs(keys) do
      vim.keymap.set("i", key, function()
        vim.cmd "stopinsert"
        require("fff.picker_ui").close()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "m", false)
      end, { buffer = args.buf, noremap = true, silent = true, desc = "Close FFF and feed keys" })
    end
    -- For shift enter capture and get the prompt
    -- Then make a new file with that name
    vim.keymap.set("i", "<s-enter>", function()
      vim.cmd "stopinsert"
      local input = require("fff.picker_ui").state.query

      require("fff.picker_ui").close()

      vim.schedule(function()
        vim.cmd('edit ' .. input)
        vim.cmd 'write'
        -- hack to fix issue with LSP not startin
        vim.cmd 'edit!'
      end)
    end, { buffer = args.buf, noremap = true, silent = true, desc = "New file" })

    -- For <c-o> open oil
    vim.keymap.set("i", "<c-o>", function()
      vim.cmd "stopinsert"
      local picker_ui = require("fff.picker_ui")

      local items = picker_ui.state.filtered_items
      if #items == 0 or picker_ui.state.cursor > #items then return end

      local item = items[picker_ui.state.cursor]
      -- print(vim.inspect(item))
      local path = item.path
      --
      -- Get parent of the path
      -- If the path is a file...
      if vim.fn.isdirectory(path) == 0 then
        path = vim.fn.fnamemodify(path, ':h')
      end

      require("fff.picker_ui").close()
      require('oil').open(path)
    end, { buffer = args.buf, noremap = true, silent = true, desc = "Oil" })
    vim.keymap.set("i", "<a-w>", function()
      -- Close fff on <m-w>
      local utils = require 'utils'
      utils.CloseTabOrQuit()
    end, { buffer = args.buf, noremap = true, silent = true, desc = "Oil" })
  end,
})
return {
  "dmtrKovalenko/fff.nvim",
  commit = "51f3259",
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
        require("utils").fff()
      end,
      desc = "Open file picker",
    },
    {
      "<c-space>",
      function()
        require("utils").fff()
      end,
      desc = "Open file picker",
    },
  },
}
