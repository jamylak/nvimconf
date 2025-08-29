-- put this in your init.lua (or a Lua plugin file)
local grp = vim.api.nvim_create_augroup("RunOnEnterButNotCmdwin", { clear = true })

vim.api.nvim_create_autocmd({ "BufWinEnter", "BufReadPost", "BufNewFile" }, {
  group = grp,
  callback = function(args)
    -- only in "normal" buffers (buftype == ""), not quickfix/term/help/cmdwin/etc.
    if vim.bo[args.buf].buftype ~= "" then return end
    -- extra safety: don't apply inside the command-line window (q:, q/, q?)
    if vim.fn.getcmdwintype() ~= "" then return end

    vim.keymap.set("n", "<CR>", function()
      -- TODO: replace with what you want to run on Enter:
      -- example: vim.cmd("write | make")
      print("Enter pressed in buffer #" .. args.buf)
    end, { buffer = args.buf, silent = true, desc = "Run on Enter (files & [No Name], not q:)" })
  end,
})


-- TODO: Move out?
local ignore_next_enter = false
vim.api.nvim_create_autocmd("TermClose", {
  -- Interestingly enough if i put this in, i open a terminal, then press ctrl-d
  -- it says "Enter pressed"...
  callback = function()
    ignore_next_enter = true
  end,
})

-- Quick binding for <enter> to open telescope cmdline
-- but also dont mess up stuff like q: which uses
-- enter to select the command
-- TODO: Doesn't apply on eg. scratchpad and stuff
-- eg. open `nvim`... and try press enter
vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function()
    if vim.bo.buftype == "" and vim.bo.filetype ~= "" then
      vim.keymap.set("n", "<enter>", function()
        if ignore_next_enter then
          ignore_next_enter = false
          return
        end
        -- Otherwise it doesn't load the config..?
        -- Somehow the office lazy keys does work but this doesn't
        require('telescope._extensions.cmdline')
        vim.cmd "Telescope cmdline"
      end, { buffer = true, desc = "Enter" })
    end
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
          map('i', '<C-k>', function()
            -- Get the current line and cursor position
            local line = vim.api.nvim_buf_get_lines(prompt_bufnr, 0, 1, false)[1] or ""
            local col = vim.api.nvim_win_get_cursor(0)[2]
            -- Keep text before cursor, remove after
            local new_line = line:sub(1, col)
            vim.api.nvim_buf_set_lines(prompt_bufnr, 0, 1, false, { new_line })
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
