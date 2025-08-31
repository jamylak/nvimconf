-- Quick binding for <enter> to open telescope cmdline
-- but also dont mess up stuff like q: which uses
-- enter to select the command
local grp = vim.api.nvim_create_augroup("RunOnEnter_RealBuffersOnly", { clear = true })

local ignore_next_enter = false
vim.api.nvim_create_autocmd("TermClose", {
  -- Interestingly enough if i put this in, i open a terminal, then press ctrl-d
  -- it says "Enter pressed"... somehow a stray enter comes from terms
  -- TODO: Just ignore term type?
  callback = function()
    ignore_next_enter = true
  end,
})


-- Part of the enter remap but sometimes buffers start as empty buffer
-- then change their type later, so in that case we need to unmap enter
-- as it screws them up
vim.api.nvim_create_autocmd("FileType", {
  group = grp,
  pattern = { "netrw", "qf", "help" }, -- add more filetypes as needed
  callback = function(args)
    local maps = vim.api.nvim_buf_get_keymap(args.buf, "n")
    if vim.b[args.buf].__enter_mapped then
      for _, map in ipairs(maps) do
        if map.lhs == "<CR>" and map.desc == "Run on Enter (files & [No Name], not q:)" then
          vim.keymap.del("n", "<CR>", { buffer = args.buf })
        end
      end
    end
  end,
})

local function map_enter(buf)
  -- only real file buffers: buftype must be empty
  -- Note that for "qf" this doesn't catch it... seems it starts with no filetype
  -- and becomes "qf" later, see above autocommand which should catch that
  if vim.bo[buf].buftype ~= "" or vim.bo[buf].filetype == "qf" then return end
  -- don't double-define
  if vim.b[buf].__enter_mapped then return end
  vim.b[buf].__enter_mapped = true

  vim.keymap.set("n", "<CR>", function()
    if ignore_next_enter then
      ignore_next_enter = false
      return
    end
    -- Otherwise it doesn't load the config..?
    -- Somehow the office lazy keys does work but this doesn't
    require('telescope._extensions.cmdline')
    vim.cmd "Telescope cmdline"
  end, { buffer = buf, silent = true, noremap = true, desc = "Run on Enter (files & [No Name], not q:)" })
end

-- Use BufEnter so it also covers already-open & newly-created buffers
vim.api.nvim_create_autocmd("BufEnter", {
  group = grp,
  callback = function(args)
    -- If somehow triggered from cmdwin, just skip (extra safety)
    if vim.fn.getcmdwintype() ~= "" then return end
    -- TODO: Maybe turn this off if there are too many problems
    map_enter(args.buf)
  end,
})

return {
  'jamylak/telescope-cmdline.nvim',
  branch = 'cmdline-edit2',
  dependencies = {},
  cmd = 'Telescope cmdline',
  keys = {
    -- Shouldn't need to do this for all mode = 'i'
    -- but setting this as default telescope binding doesn't work well eg.
    -- it is loading the extension without this config
    -- Couldn't be bothered to fix
    { '<m-space>', '<cmd>Telescope cmdline<cr>', desc = 'Telescope cmdline', mode = 'i' },
    { '<m-space>', '<cmd>Telescope cmdline<cr>', desc = 'Telescope cmdline', mode = 'n' },
    -- Backup incase alt-space overriden
    { '<leader>:', '<cmd>Telescope cmdline<cr>', desc = 'Telescope cmdline', mode = 'n' },
    { '<m-;>',     '<cmd>Telescope cmdline<cr>', desc = 'Telescope cmdline', mode = 'n' },
  },
  config = function()
    -- TODO: Override C-j to do <enter>
    require('telescope').load_extension 'cmdline'

    require('telescope._extensions.cmdline').setup {
      picker = {
        layout_config = {
          width = 120,
          height = 25,
        },
        attach_mappings = function(prompt_bufnr, map)
          map('i', '<S-CR>', function()
            -- Get the current input from the prompt buffer
            -- and just run it as is without the telescope stuff
            local current_input = vim.api.nvim_buf_get_lines(prompt_bufnr, 0, -1, false)[1] or ""
            -- Remove leading/trailing whitespace and leading ':'
            local cmd = current_input
            require('telescope.actions').close(prompt_bufnr)
            if cmd ~= "" then
              vim.cmd(cmd)
            end
          end)
          map('i', '<C-f>', function()
            -- Get the current input from the prompt buffer
            local current_input = vim.api.nvim_buf_get_lines(prompt_bufnr, 0, -1, false)[1] or ""
            print("Current input: " .. current_input)
            -- Close the Telescope picker
            require('telescope.actions').close(prompt_bufnr)

            -- Construct the command to feed: enter command mode, type the input, then literally press <C-f>
            -- The current_input from telescope-cmdline already includes the leading ':'
            -- Remove starting space from current_input
            current_input = current_input:gsub('^%s+:%s+', ':')
            local cmd_to_feed = current_input .. "<C-f>"
            -- local cmd_to_feed = ":pwd" .. "<C-f>"
            local keys = vim.api.nvim_replace_termcodes(cmd_to_feed, true, false, true)
            vim.api.nvim_feedkeys(keys, 'n', false)
          end)
          return true
        end,
      },
    }
  end,
}
