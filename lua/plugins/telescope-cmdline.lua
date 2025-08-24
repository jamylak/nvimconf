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
        -- These both fail
        -- I want a way eventually to do something like
        -- :<c-f>
        attach_mappings = function(prompt_bufnr, map)
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
        -- mappings = {
        --   i = {
        --     ["<C-f>"] = function(prompt_bufnr)
        --       print("hello world")
        --     end,
        --   },
        -- },
      },
    }
  end,
}
