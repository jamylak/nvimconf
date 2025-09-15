return {
  'prichrd/netrw.nvim',
  init = function()
    if #vim.fn.argv() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
      -- Only load this if Neovim was started with a directory argument
      require("netrw")
    elseif vim.g.neovide then
      -- Load netrw if in Neovide (to handle file browsing)
      -- Really it's only needed IF it was started with a
      -- dir arg but this works and isnt too slow
      require("netrw")
    end
  end,
  opts = {}
}
