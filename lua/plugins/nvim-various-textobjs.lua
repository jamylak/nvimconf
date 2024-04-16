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

    -- Telescope picker for URL selection
    local pickers = require 'telescope.pickers'
    local finders = require 'telescope.finders'
    local conf = require('telescope.config').values
    local action_state = require 'telescope.actions.state'
    local actions = require 'telescope.actions'

    pickers
      .new({}, {
        prompt_title = 'Select URL:',
        finder = finders.new_table {
          results = urls,
          entry_maker = function(entry)
            return {
              value = entry,
              display = entry,
              ordinal = entry,
            }
          end,
        },
        sorter = conf.generic_sorter {},
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            if selection then
              openURL(selection.value)
            end
          end)
          return true
        end,
      })
      :find()
  end
end, { desc = 'URL Opener' })
return {
  'chrisgrieser/nvim-various-textobjs',
  event = 'BufReadPre',
  opts = {
    useDefaultKeymaps = true,
    lookForwardSmall = 10,
    lookForwardBig = 25,
    -- disable these cause they conflict with
    -- ctrl-v replace. We could find a way to allow r but just
    -- not in visual line mode. maybe extend disabled keymaps
    -- to take a mode or just unamp this in visual mode
    -- Also disabling n because i can't extend a highlight with /
    -- but would be good to get it back
    -- could do a custom binding based off docs
    disabledKeymaps = { 'r', 'n' },
  },
}
