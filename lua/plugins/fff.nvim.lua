local function reopen_fff(fn)
  local ok, picker_ui = pcall(require, 'fff.picker_ui')
  if ok and picker_ui.state and picker_ui.state.active then picker_ui.close() end

  vim.schedule(function()
    fn()
    vim.schedule(function()
      vim.cmd 'startinsert'
    end)
  end)
end

local function open_fuzzy_file_picker()
  reopen_fff(function()
    require('fff').find_files()
  end)
end

local function open_fuzzy_live_grep(query, cwd)
  reopen_fff(function()
    require('fff').live_grep({
      cwd = cwd,
      query = query or '',
      grep = {
        modes = { 'fuzzy', 'plain' },
      },
    })
  end)
end

local function open_telescope_all_grep(query, cwd)
  local ok, picker_ui = pcall(require, 'fff.picker_ui')
  if ok and picker_ui.state and picker_ui.state.active then picker_ui.close() end

  vim.schedule(function()
    require('telescope.builtin').live_grep({
      cwd = cwd,
      prompt_title = 'Live Grep - Global',
      default_text = query or '',
      additional_args = function()
        return { '--hidden', '--no-ignore' }
      end,
    })
  end)
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'fff_input',
  callback = function(args)
    -- Feed through these to telescope
    local keys = { '<a-i>', '<a-y>', '<a-space>', '<a-o>', '<a-g>', '<a-n>', '<c-g>', '<a-;>' }
    for _, key in ipairs(keys) do
      vim.keymap.set('i', key, function()
        vim.cmd 'stopinsert'
        require('fff.picker_ui').close()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), 'm', false)
      end, { buffer = args.buf, noremap = true, silent = true, desc = 'Close FFF and feed keys' })
    end
    vim.keymap.set('i', '<a-u>', function()
      local picker_ui = require 'fff.picker_ui'
      local query = picker_ui.state.query
      local cwd = picker_ui.state.config and picker_ui.state.config.base_path or vim.uv.cwd()

      vim.cmd 'stopinsert'
      if picker_ui.state.mode == 'grep' then
        open_telescope_all_grep(query, cwd)
      else
        open_fuzzy_live_grep(query, cwd)
      end
    end, { buffer = args.buf, noremap = true, silent = true, desc = 'FFF live grep' })
    -- For shift enter capture and get the prompt
    -- Then make a new file with that name
    vim.keymap.set('i', '<s-enter>', function()
      vim.cmd 'stopinsert'
      local input = require('fff.picker_ui').state.query

      require('fff.picker_ui').close()

      vim.schedule(function()
        vim.cmd('edit ' .. input)
        vim.cmd 'write'
        -- hack to fix issue with LSP not startin
        vim.cmd 'edit!'
      end)
    end, { buffer = args.buf, noremap = true, silent = true, desc = 'New file' })

    -- For <c-o> open oil
    vim.keymap.set('i', '<c-o>', function()
      vim.cmd 'stopinsert'
      local picker_ui = require 'fff.picker_ui'

      local items = picker_ui.state.filtered_items
      if #items == 0 or picker_ui.state.cursor > #items then
        return
      end

      local item = items[picker_ui.state.cursor]
      -- print(vim.inspect(item))
      local path = item.path
      --
      -- Get parent of the path
      -- If the path is a file...
      if vim.fn.isdirectory(path) == 0 then
        path = vim.fn.fnamemodify(path, ':h')
      end

      require('fff.picker_ui').close()
      require('oil').open(path)
    end, { buffer = args.buf, noremap = true, silent = true, desc = 'Oil' })
    vim.keymap.set('i', '<a-w>', function()
      -- Close fff on <m-w>
      local utils = require 'utils'
      utils.CloseTabOrQuit()
    end, { buffer = args.buf, noremap = true, silent = true, desc = 'Oil' })
  end,
})
return {
  'dmtrKovalenko/fff.nvim',
  build = function()
    -- this will download prebuild binary or try to use existing rustup toolchain to build from source
    -- (if you are using lazy you can use gb for rebuilding a plugin if needed)
    require('fff.download').download_or_build_binary()
  end,
  cmd = {
    'FFF',
    'FFFFind',
    'FFFScan',
    'FFFRefreshGit',
    'FFFClearCache',
    'FFFHealth',
    'FFFDebug',
    'FFFOpenLog',
  },
  -- or if you are using nixos
  -- build = "nix run .#release",
  opts = {
    -- pass here all the options
    keymaps = {
      close = { '<Esc>', '<C-c>' },
      select = { '<CR>', '<C-j>', '<C-m>' },
    },
  },
  keys = {
    {
      '<leader>F',
      function()
        open_fuzzy_file_picker()
      end,
      desc = 'Open file picker',
    },
    {
      '<c-space>',
      function()
        open_fuzzy_file_picker()
      end,
      desc = 'Open file picker',
    },
    {
      '<c-return>',
      function()
        open_fuzzy_file_picker()
      end,
      desc = 'Open file picker',
    },
    {
      'fg',
      function()
        require('fff').live_grep()
      end,
      desc = 'LiFFFe grep',
    },
    {
      '<m-u>',
      function()
        open_fuzzy_live_grep()
      end,
      desc = 'FFF find word',
    },
  },
}
