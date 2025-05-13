return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  -- event = 'VimEnter',
  cmd = 'Telescope',
  keys = {
    '<leader>fh',
    '<leader>fm',
    '<leader>fk',
    '<leader>ff',
    '<leader>sj',
    '<leader>sf',
    '<leader>fF',
    '<leader>sF',
    '<leader>ft',
    '<leader>fc',
    '<leader>sc',
    '<leader>fC',
    '<leader>fw',
    '<leader>fW',
    '<leader>/',
    '<leader>gs',
    '<leader>fg',
    '<leader>gS',
    '<leader>gf',
    '<leader>fy',
    '<leader>gb',
    '<leader>gc',
    -- '<leader>gj',
    '<leader>gk',
    '<leader>sk',
    '<leader>sw',
    '<leader>fp',
    '<leader>fr',
    '<leader>fd',
    '<leader>f<CR>',
    '<leader><CR>',
    'su',
    'so',
    'si',
    '<m-o>',
    '<m-i>',
    '<m-u>',
    '<m-b>',
    '<m-CR>',
    '<leader>j',
    '<leader>k',
    '<leader>fj',
    '<leader>sm',
    '<leader>sb',
    '<leader>fb',
    '<leader>`',
    '<leader>fj',
    '<leader>f/',
    '<leader>sn',
    '<leader>fn',
    'sn',
    '<leader>f.',
    '<leader>f,',
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for install instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    -- { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires special font.
    --  If you already have a Nerd Font, or terminal set up with fallback fonts
    --  you can enable this
    { 'nvim-tree/nvim-web-devicons' },
  },
  config = function()
    -- Telescope is a fuzzy finder that comes with a lot of different things that
    -- it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!
    --
    -- The easiest way to use telescope, is to start by doing something like:
    --  :Telescope help_tags
    --
    -- After running this command, a window will open up and you're able to
    -- type in the prompt window. You'll see a list of help_tags options and
    -- a corresponding preview of the help.
    --
    -- Two important keymaps to use while in telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    local function setCWDToPicker(prompt_bufnr, openFile)
      -- Set the current working directory to the picker
      local action_state = require 'telescope.actions.state'
      local pickerCWD = action_state.get_current_picker(prompt_bufnr).cwd
      local selection = action_state.get_selected_entry()
      local path = selection.value
      if pickerCWD then
        path = pickerCWD .. '/' .. path
      end
      local utils = require 'utils'
      utils.tcd_to_git_root(path)
      if openFile then
        -- Finish the picker and open the file
        require('telescope.actions').select_default(prompt_bufnr)
      end
    end

    local function setCWDToPickerAndFindFiles(prompt_bufnr)
      setCWDToPicker(prompt_bufnr)
      vim.cmd 'Telescope find_files'
    end

    local function setCWDToPickerAndOpen(prompt_bufnr)
      setCWDToPicker(prompt_bufnr, true)
    end

    local function openOil()
      -- Open oil at the currrrent directory
      -- First get the current telescope directory
      local prompt_bufnr = vim.api.nvim_get_current_buf()
      local actions = require 'telescope.actions'
      local action_state = require 'telescope.actions.state'

      -- Get the current selcetion
      local selection = action_state.get_selected_entry()
      local path = selection.value

      -- Check if path doesn't start with a /
      if not path:match '^/' then
        path = selection.cwd .. '/' .. path
      end

      -- Get parent of the path
      -- If the path is a file...
      if vim.fn.isdirectory(path) == 0 then
        path = vim.fn.fnamemodify(path, ':h')
      end

      -- Close telescope
      actions.close(prompt_bufnr)
      require('oil').open(path)
    end

    require('telescope').setup {
      extensions = {},
      defaults = {
        layout_strategy = 'horizontal',
        layout_config = {
          height = 0.95,
          width = 0.92,
          preview_width = 0.45,
        },
        mappings = {
          i = {
            ['<S-Enter>'] = function(prompt_bufnr)
              -- Create new file
              local action_state = require 'telescope.actions.state'
              local actions = require 'telescope.actions'
              local input = action_state.get_current_line()
              if input and input ~= '' then
                actions.close(prompt_bufnr)
                vim.schedule(function()
                  vim.cmd('edit ' .. input)
                  vim.cmd 'write'
                  -- hack to fix issue with LSP not startin
                  vim.cmd 'edit!'
                end)
              end
            end,
            ['<c-o>'] = openOil,
            ['<c-h>'] = require('telescope.actions').select_horizontal,
            ['<c-enter>'] = 'to_fuzzy_refine',
            ['<c-j>'] = setCWDToPickerAndFindFiles,
            ['<c-g>'] = function(prompt_bufnr)
              require('telescope.actions').close(prompt_bufnr)
              vim.cmd '-tabnew'
              require('neogit').open { kind = 'replace' }
            end,
            ['<m-w>'] = function()
              local utils = require 'utils'
              utils.CloseTabOrQuit()
            end,
            ['<m-return>'] = setCWDToPickerAndOpen,
            ['<m-u>'] = function()
              vim.cmd 'Telescope live_grep'
            end,
            ['<m-o>'] = function()
              vim.cmd 'Telescope oldfiles'
            end,
            ['<m-i>'] = function()
              vim.cmd 'Telescope find_files'
            end,
            ['<m-v>'] = function(prompt_bufnr)
              -- Telescope is looking through wrong working dir, fix it..
              --
              -- Get the name of the current file, not the telescope modal
              -- buffer, the file that is currently open behind telescope
              local utils = require 'utils'
              local path = vim.api.nvim_buf_get_name(vim.fn.winbufnr(vim.fn.winnr '#'))
              -- Change to dir of the current file and now refresh telescope
              utils.cd_to_git_root(path)
              -- Now reload telescope
              local action_state = require 'telescope.actions.state'
              local current_picker = action_state.get_current_picker(prompt_bufnr)

              -- hacky - hardcoded just to work with these 2 well for now
              -- other pickers need to change
              -- until figure out how to replace this with refresh()
              if current_picker.prompt_title == 'Live Grep' then
                vim.cmd 'Telescope live_grep'
              else
                vim.cmd 'Telescope find_files'
              end
            end,
            -- ['<m-n>'] = require('telescope.actions.layout').cycle_layout_next,
            -- vim.keymap.set('n', '<m-o>', builtin.oldfiles, { silent = true, desc = '[F]ind Recent' })
            ['<m-y>'] = function()
              local utils = require 'utils'
              utils.yazi()
            end,

            ['<m-g>'] = function()
              local utils = require 'utils'
              utils.lazygit()
            end,
            ['<m-t>'] = function()
              local selection = require('telescope.actions.state').get_selected_entry()
              vim.cmd('tabnew ' .. selection.value)
              local utils = require 'utils'
              utils.tcd_to_git_root(selection.value)
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, true, true), 'n', true)
            end,
          },
          n = {
            ['o'] = openOil,
            ['q'] = require('telescope.actions').close,
            ['v'] = require('telescope.actions').select_vertical,
            ['h'] = require('telescope.actions').select_horizontal,
            ['t'] = require('telescope.actions').select_tab,
            ['T'] = function()
              local selection = require('telescope.actions.state').get_selected_entry()
              vim.cmd('tabnew ' .. selection.value)
              -- Now bring back telescope
              vim.cmd 'Telescope resume'
              -- Enter normal mode again by doing escape
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, true, true), 'n', true)
            end,
            ['cd'] = setCWDToPicker,
          },
        },
      },
      pickers = {
        find_files = {
          mappings = {
            -- i = {
            --   ['<Backspace>'] = function(prompt_bufnr)
            --     -- Go up one
            --   end,
            --   ['..'] = function() end,
            -- },
          },
        },
      },
      -- extensions = {
      --   ['ui-select'] = {
      --     require('telescope.themes').get_dropdown(),
      --   },
      -- },
    }
    local function getCWD()
      local path = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
      -- If path starts with oil:// then get the part after
      if string.match(path, '^oil://') then
        path = string.sub(path, 7)
      else
        path = vim.fn.expand '%:p:h'
      end
      return path
    end

    -- Enable telescope extensions, if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    -- pcall(require('telescope').load_extension, 'ui-select')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'

    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
    vim.keymap.set('n', '<leader>fm', builtin.man_pages, { desc = '[F]ind [M]an' })
    vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
    vim.keymap.set('n', '<leader>.', function()
      builtin.find_files { no_ignore = false, cwd = getCWD(), prompt_title = 'Find files (cwd)' }
    end, { desc = '[F]ind [F]iles (cwd)' })
    vim.keymap.set('n', '<leader>ff', function()
      builtin.find_files { no_ignore = false }
    end, { desc = '[F]ind [F]iles' })
    vim.keymap.set('n', '<leader>sj', function()
      builtin.find_files { no_ignore = false, cwd = getCWD(), prompt_title = 'Find files (cwd)' }
    end, { desc = '[F]ind [F]iles (cwd)' })
    vim.keymap.set('n', '<leader>sf', function()
      builtin.find_files { no_ignore = false, cwd = getCWD(), prompt_title = 'Find files (cwd)' }
    end, { desc = '[F]ind [F]iles (cwd)' })
    vim.keymap.set('n', '<leader>fF', function()
      builtin.find_files { no_ignore = true, hidden = true }
    end, { desc = '[F]ind All [F]iles' })
    vim.keymap.set('n', '<leader>sF', function()
      builtin.find_files { no_ignore = true, hidden = true, prompt_title = 'Find files (cwd)', cwd = getCWD() }
    end, { desc = '[F]ind All [F]iles (cwd)' })
    vim.keymap.set('n', '<leader>ft', builtin.builtin, { desc = '[F]ind [T]elescope' })
    vim.keymap.set('n', '<leader>fc', builtin.grep_string, { desc = '[F]ind current [W]ord' })
    vim.keymap.set('n', '<leader>sc', function()
      builtin.grep_string { cwd = getCWD(), prompt_title = 'Find current word (cwd)' }
    end, { desc = '[F]ind current [W]ord (cwd)' })
    vim.keymap.set('n', '<leader>fC', builtin.command_history, { desc = '[F]ind [C]ommands' })
    vim.keymap.set('n', '<leader>fj', builtin.command_history, { desc = '[F]ind [C]ommands' })
    vim.keymap.set('n', '<leader>fw', builtin.live_grep, { desc = '[F]ind [W]ord' })
    vim.keymap.set('n', '<m-u>', builtin.live_grep, { desc = '[F]ind [W]ord' })
    vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'Find Word' })
    -- Git status
    vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = '[G]it [S]tatus' })
    vim.keymap.set('n', '<leader>fg', builtin.git_status, { desc = '[G]it [S]tatus' })
    vim.keymap.set('n', '<leader>gS', builtin.git_stash, { desc = '[G]it [S]tash' })
    -- Git files
    vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = '[G]it [F]iles' })
    vim.keymap.set('n', '<leader>fy', builtin.git_files, { desc = '[G]it [F]iles' })
    -- Git branches
    vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = '[G]it [B]ranches' }) -- Git commits
    vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = '[G]it [C]ommits' })
    -- vim.keymap.set('n', '<leader>gj', builtin.git_files, { desc = '[G]it [F]iles' })
    vim.keymap.set('n', '<leader>gk', builtin.git_commits, { desc = '[G]it Commits' })

    vim.keymap.set('n', '<leader>sk', function()
      builtin.live_grep { cwd = getCWD(), prompt_title = 'Find word (cwd)' }
    end, { desc = '[F]ind [W]ord in Current Dir' })
    vim.keymap.set('n', '<leader>sw', function()
      builtin.live_grep { cwd = getCWD(), prompt_title = 'Find word (cwd)' }
    end, { desc = '[F]ind [W]ord in Current Dir' })

    vim.keymap.set('n', '<leader>fp', function()
      builtin.live_grep { prompt_title = 'Find words in projects', cwd = os.getenv 'PROJECTS_DIR' }
    end, { desc = '[F]ind Words in Projects' })
    vim.keymap.set('n', '<leader>fr', builtin.registers, { desc = '[F]ind [R]egisters' })
    vim.keymap.set('n', '<leader>fW', function()
      builtin.live_grep {
        prompt_title = 'Find words in all files',
        additional_args = function(opts)
          return { '--hidden', '--no-ignore' }
        end,
      }
    end, { desc = 'Find words in all files (cwd)' })
    vim.keymap.set('n', '<leader>sW', function()
      builtin.live_grep {
        prompt_title = 'Find words in all files (cwd)',
        cwd = getCWD(),
        additional_args = function(opts)
          return { '--hidden', '--no-ignore' }
        end,
      }
    end, { desc = 'Find words in all files' })
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
    vim.keymap.set('n', '<leader>f<CR>', builtin.resume, { desc = '[F]ind [R]esume' })
    vim.keymap.set('n', '<m-CR>', builtin.resume, { desc = '[F]ind [R]esume' })
    vim.keymap.set('n', '<leader><CR>', builtin.resume, { desc = '[F]ind [R]esume' })
    vim.keymap.set('n', 'su', builtin.live_grep, { silent = true, desc = 'Live Grep' })
    vim.keymap.set('n', 'so', builtin.oldfiles, { silent = true, desc = '[F]ind Recent' })
    vim.keymap.set('n', '<m-o>', builtin.oldfiles, { silent = true, desc = '[F]ind Recent' })
    vim.keymap.set('n', 'si', function()
      builtin.find_files { silent = true, no_ignore = false }
    end, { desc = '[F]ind [F]iles' })
    vim.keymap.set('n', '<m-i>', function()
      builtin.find_files { silent = true, no_ignore = false }
    end, { desc = '[F]ind [F]iles' })
    vim.keymap.set('n', '<leader>j', function()
      builtin.find_files { silent = true, no_ignore = false }
    end, { desc = '[F]ind [F]iles' })
    vim.keymap.set('n', '<leader>k', function()
      builtin.live_grep {
        prompt_title = 'Find words in all files',
        additional_args = function(opts)
          return { '--hidden', '--no-ignore' }
        end,
      }
    end, { desc = 'Find words in all files (cwd)' })
    vim.keymap.set('n', '<leader>sm', builtin.marks, { desc = '[S]earch [M]arks' })

    local function deleteBuffer(prompt_bufnr)
      -- Currently if it's the last buffer it deletes it
      -- but since it's still open nothing really happens
      -- local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
      -- if buftype == 'terminal' then
      --   vim.api.nvim_buf_delete(prompt_bufnr, {})
      -- end
      local action_state = require 'telescope.actions.state'
      local selection = action_state.get_selected_entry()
      local buftype = vim.api.nvim_buf_get_option(selection.bufnr, 'buftype')
      require('telescope.actions').delete_buffer(prompt_bufnr)

      -- Fixes error with deleting terminals
      if buftype == 'terminal' then
        vim.api.nvim_buf_delete(selection.bufnr, { force = true })
      end
    end

    vim.keymap.set('n', '<m-b>', function()
      -- Like normal search buffers but also with option to delete
      builtin.buffers {
        attach_mappings = function(_, map)
          map('i', '<c-r>', deleteBuffer)
          map('n', 'D', deleteBuffer)
          return true
        end,
      }
    end, { desc = '[S]earch [B]uffers' })

    vim.keymap.set('n', '<leader>sb', function()
      -- Like normal search buffers but also with option to delete
      builtin.buffers {
        attach_mappings = function(_, map)
          map('i', '<c-r>', deleteBuffer)
          map('n', 'D', deleteBuffer)
          return true
        end,
      }
    end, { desc = '[S]earch [B]uffers' })
    -- Can remap <leader><leader> to something more useful
    -- vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[S]earch [B]uffers' })
    vim.keymap.set('n', '<leader>fb', function()
      builtin.find_files {
        prompt_title = 'Find Projects',
        cwd = os.getenv 'PROJECTS_DIR',
      }
    end, { desc = '[ ] Find projects' })
    vim.keymap.set('n', '<leader>`', builtin.marks, { desc = 'Find marks' })

    -- Also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>f/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[F]ind [/] in Open Files' })

    -- Shortcut for searching your neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[F]ind [N]eovim Files' })
    vim.keymap.set('n', '<leader>fn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[F]ind [N]eovim Files' })
    vim.keymap.set('n', 'sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[F]ind [N]eovim Files' })

    local function searchDotFiles()
      builtin.find_files {
        find_command = {
          'fd',
          '^\\.',
          os.getenv 'HOME',
          '-d',
          '1',
          '-t',
          'f',
          '-H',
          '-L', -- Follow symlinks
        },
      }
    end
    local function searchConfigFiles()
      builtin.find_files {
        find_command = {
          'fd',
          '.',
          os.getenv 'HOME' .. '/.config/',
          '-H',
          '--exclude',
          'gcloud',
          '--exclude',
          '.git',
        },
      }
    end

    -- Key mapping to invoke the custom search function
    vim.keymap.set('n', '<leader>f.', searchDotFiles, { desc = '[F]ind [.] files' })
    vim.keymap.set('n', '<leader>f,', searchConfigFiles, { desc = '[F]ind Config files' })
  end,
}
