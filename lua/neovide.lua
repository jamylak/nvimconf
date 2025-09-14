-- Neovide settings
if vim.g.neovide then
  vim.schedule(function()
    -- https://github.com/neovide/neovide/blob/db41b205200aff74530910bb5f9d666b8ffcde55/lua/init.lua#L131
    -- https://github.com/neovide/neovide/blob/db41b205200aff74530910bb5f9d666b8ffcde55/src/bridge/ui_commands.rs#L209
    -- Override Neovide specific dropfile to properly handle Finder opening Files with Neovide
    if _G.neovide and _G.neovide.private and _G.neovide.private.dropfile then
      local orig = _G.neovide.private.dropfile
      _G.neovide.private.dropfile = function(filename, tabs)
        vim.schedule(function()
          local utils = require 'utils'
          -- Make sure to tcd for new files
          -- TODO: Backup normal cd to the file if git didnt work
          utils.tcd_to_git_root()
          -- Hacky bug fix to stop LSP and formatter not working
          vim.cmd 'edit'
          vim.defer_fn(function()
            -- hacky bug fix to stop it getting stuck in insert mode
            -- (i think from telescope just having been open)
            vim.cmd "stopinsert"
          end, 50)
        end)
        return orig(filename, tabs)
      end
    end
  end)

  -- vim.api.nvim_set_keymap('n', '<D-v>', '"*p', { noremap = true })
  vim.o.guifont = 'Fira Code Medium:h18'
  -- Set current working directory to the project directory env var
  local projects_dir = os.getenv 'PROJECTS_DIR'
  vim.cmd('cd ' .. projects_dir)
  -- vim.api.nvim_set_keymap('i', '<D-v>', '<cmd><ESC> "*P<cr>', { noremap = true })
  vim.keymap.set('i', '<D-v>', '<C-r>*')            -- Paste insert mode
  vim.keymap.set('t', '<D-v>', '<C-\\><C-n>l"+Pli') -- Paste insert mode

  local function paste_in_terminal()
    -- Get the clipboard content
    local clipboard_content = vim.fn.getreg '+'
    -- Send the clipboard content directly to the terminal
    local current_buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_chan_send(vim.b[current_buf].terminal_job_id, clipboard_content)
  end

  -- Hacky bugfix to close any open telescope windows when
  -- opening a file from Finder or Spotlight
  -- Since i put an auto telescope on app startup but files get sent in soon after
  vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    callback = function()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "TelescopePrompt" then
          require("telescope.actions").close(require("telescope.actions.state").get_current_picker(buf).prompt_bufnr)
        end
      end
    end,
  })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "TelescopePrompt" then
          require("telescope.actions").close(require("telescope.actions.state").get_current_picker(buf).prompt_bufnr)
        end
      end
    end,
  })


  vim.keymap.set('t', '<D-v>', paste_in_terminal)
  vim.keymap.set('n', '<D-v>', '"+P')    -- Paste normal mode
  vim.keymap.set('v', '<D-v>', '"+P')    -- Paste visual mode
  vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
  vim.g.neovide_input_macos_option_key_is_meta = 'both'
  vim.o.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20'
  -- Set ENV var SHELL to fish
  vim.o.shell = '/opt/homebrew/bin/fish'

  -- For mode in Normal, Terminal, and Visual
  for _, mode in ipairs { 'i', 'n', 't', 'v' } do
    -- If we are in terminal mode, cmdPrefix is <C-\><C-n>
    -- If we are in normal mode, cmdPrefix is empty
    -- If we are in insert mode cmdPrefix is <ESC>
    local cmd = ''
    if mode == 't' then
      cmd = '<C-\\><C-n>'
    elseif mode == 'i' then
      cmd = '<ESC>'
    end
    -- Terminal shortcut
    vim.api.nvim_set_keymap(mode, '<D-j>', cmd .. ' te', { silent = true })
    -- Set D-0 to D-9 to escape then switch to the corresponding tab
    for i = 0, 9 do
      vim.api.nvim_set_keymap(mode, '<D-' .. i .. '>', cmd .. ':' .. i .. 'tabnext<CR>',
        { noremap = true, silent = true })
    end

    -- Set D-Shift-[ to D-Shift-] to switch to the previous/next tab
    vim.api.nvim_set_keymap(mode, '<D-{>', cmd .. ':tabprevious<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap(mode, '<D-}>', cmd .. ':tabnext<CR>', { noremap = true, silent = true })

    vim.api.nvim_set_keymap(mode, '<D-]>', '<C-w>w', { silent = true })
    vim.api.nvim_set_keymap(mode, '<D-[>', '<C-w>W', { silent = true })

    local utils = require 'utils'
    -- Set D-T to open a new tab
    vim.keymap.set(mode, '<D-t>', utils.terminalNewTab, { noremap = true, silent = true })
    vim.keymap.set(mode, '<D-\\>', utils.terminalVSplit, { noremap = true, silent = true })
    vim.keymap.set(mode, '<D-CR>', utils.terminalHSplit, { noremap = true, silent = true })
    vim.keymap.set(mode, '<D-g>', function()
      vim.api.nvim_feedkeys(cmd, 'n', false)
      vim.cmd '-tabnew | term lazygit'
      vim.cmd 'startinsert'
    end, { noremap = true })
    -- quick test: replicate <leader>i which does explorer reveal
    vim.api.nvim_set_keymap(mode, '<D-i>', cmd .. ' i', { silent = true })
    -- quick test to open up IDE style diagnostics and symbols
    vim.api.nvim_set_keymap(mode, '<D-k>', cmd .. ' b', { silent = true })

    vim.api.nvim_set_keymap(mode, '<D-w>', cmd .. ':tabclose<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap(mode, '<D-o>', cmd .. ':tabonly<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap(mode, '<D-n>', cmd .. '<m-n>', { silent = true })
    -- vim.api.nvim_set_keymap(mode, '<D-O>', cmd .. ':only<CR>', { noremap = true, silent = true })

    -- Set D-F to run keybinding 'su' which is find on recent files
    vim.api.nvim_set_keymap(mode, '<D-f>', cmd .. 'su', { silent = true })

    vim.g.neovide_scale_factor = 1.0
    local change_scale_factor = function(delta)
      vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
    end
    vim.keymap.set(mode, '<D-=>', function()
      change_scale_factor(1.25)
    end, { silent = true })
    vim.keymap.set(mode, '<D-->', function()
      change_scale_factor(1 / 1.25)
    end, { silent = true })
  end

  -- Test
  -- vim.api.nvim_set_keymap('t', '<D-k>', '<C-\\><C-n>gf:CD<CR>', { noremap = true, silent = true })

  -- Hacky neovide fixes for opening files either from
  -- Finder / Spotlight or opening without a file
  vim.schedule(function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local utils = require 'utils'
    if string.find(bufname, 'oil') or vim.bo.filetype == 'netrw' then
      utils.tcd_to_git_root()
      vim.cmd 'Telescope find_files'
    elseif bufname == '' then
      -- It's the empty buffer, so we didn't open neovide
      -- with a file, so show old files selector
      utils.fzfDir()
    end
  end)
end

vim.g.neovide_confirm_quit = false
vim.g.neovide_scroll_animation_length = 0.05
vim.g.neovide_opacity = 0.8
vim.g.neovide_window_blurred = true
vim.g.neovide_normal_opacity = 0.05
-- Doesn't seem to do anything
vim.g.neovide_show_border = true
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_cursor_antialiasing = true
vim.g.neovide_cursor_animate_command_line = true
vim.g.neovide_cursor_unfocused_outline_width = 0.18

--- Doesn't seem to work?
vim.g.neovide_title_background_color = "red"
vim.g.neovide_title_text_color = "pink"

vim.g.neovide_floating_blur_amount_x = 8.0
vim.g.neovide_floating_blur_amount_y = 8.0


-- Railgun
-- vim.g.neovide_cursor_vfx_mode = 'railgun'
-- vim.g.neovide_cursor_vfx_opacity = 700.0
-- vim.g.neovide_cursor_vfx_particle_lifetime = 0.7
-- vim.g.neovide_cursor_vfx_particle_density = 43.0
-- vim.g.neovide_cursor_vfx_particle_speed = 13.0
-- vim.g.neovide_cursor_vfx_particle_phase = 30.5
-- vim.g.neovide_cursor_vfx_particle_curl = 0.3

-- Pixiedust
vim.g.neovide_cursor_vfx_mode = 'pixiedust'
vim.g.neovide_cursor_vfx_opacity = 1000.0
vim.g.neovide_cursor_vfx_particle_lifetime = 0.5
vim.g.neovide_cursor_vfx_particle_density = 100.0
vim.g.neovide_cursor_vfx_particle_speed = 10.0
