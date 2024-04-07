local keymap = vim.keymap.set
keymap({ 'o', 'x' }, 'id', "<cmd>lua require('various-textobjs').number('inner')<CR>")
keymap({ 'o', 'x' }, 'ad', "<cmd>lua require('various-textobjs').number('outer')<CR>")

-- https://github.com/chrisgrieser/nvim-various-textobjs?tab=readme-ov-file
local function openURL(url)
  local opener
  if vim.fn.has 'macunix' == 1 then
    opener = 'open'
  elseif vim.fn.has 'linux' == 1 then
    opener = 'xdg-open'
  elseif vim.fn.has 'win64' == 1 or vim.fn.has 'win32' == 1 then
    opener = 'start'
  end
  local openCommand = string.format("%s '%s' >/dev/null 2>&1", opener, url)
  vim.fn.system(openCommand)
end

vim.keymap.set('n', 'gX', function()
  require('various-textobjs').url()
  local foundURL = vim.fn.mode():find 'v'
  if foundURL then
    vim.cmd.normal '"zy'
    local url = vim.fn.getreg 'z'
    openURL(url)
  else
    -- find all URLs in buffer
    local urlPattern = require('various-textobjs.charwise-textobjs').urlPattern
    local bufText = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')
    local urls = {}
    for url in bufText:gmatch(urlPattern) do
      table.insert(urls, url)
    end
    if #urls == 0 then
      return
    end

    -- select one, use a plugin like dressing.nvim for nicer UI for
    -- `vim.ui.select`
    vim.ui.select(urls, { prompt = 'Select URL:' }, function(choice)
      if choice then
        openURL(choice)
      end
    end)
  end
end, { desc = 'URL Opener' })

return {
  'chrisgrieser/nvim-various-textobjs',
  event = 'BufReadPost',
  opts = {
    useDefaultKeymaps = true,
    lookForwardSmall = 10,
    lookForwardBig = 25,
  },
  disabledKeymaps = { 'in', 'an' },
}
