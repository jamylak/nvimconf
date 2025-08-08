return {
  'jamylak/telescope-cmdline.nvim',
  branch = 'cmdline-edit',
  dependencies = {},
  cmd = 'Telescope cmdline',
  keys = {
    { '<m-space>', '<cmd>Telescope cmdline<cr>', desc = 'Telescope cmdline', mode = 'n' },
    { '<m-space>', '<cmd>Telescope cmdline<cr>', desc = 'Telescope cmdline', mode = 'i' },
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
            -- local cmd_to_feed = current_input .. "<C-f>"
            local cmd_to_feed = current_input
            --
            -- Feed the keys to Neovim
            -- 'n' for normal mode (to ensure we enter command mode), 'x' for execute, true for remap
            vim.api.nvim_feedkeys(cmd_to_feed, 'nx', true)
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
