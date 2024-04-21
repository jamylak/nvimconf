return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
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
    { 'nvim-telescope/telescope-ui-select.nvim' },

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
    local function setCWDtoPicker()
      -- Set the current working directory to the picker
      local prompt_bufnr = vim.api.nvim_get_current_buf()
      local actions = require 'telescope.actions'
      local action_state = require 'telescope.actions.state'
      local action_utils = require 'telescope.actions.utils'
      local current_picker = action_state.get_current_picker(prompt_bufnr)

      -- Set the current working directory to the picker
      vim.api.nvim_set_current_dir(current_picker.cwd)
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

    -- TODO: Default SHIFT ENTER = create file if the path is there
    -- Unless it's a DIR eg. /tmp in which case navigate there

    require('telescope').setup {
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      --
      defaults = {
        mappings = {
          i = {
            ['<c-o>'] = openOil,
            ['<c-h>'] = require('telescope.actions').select_horizontal,
            ['<c-enter>'] = 'to_fuzzy_refine',
          },
          n = {
            ['o'] = openOil,
            ['q'] = require('telescope.actions').close,
            ['v'] = require('telescope.actions').select_vertical,
            ['h'] = require('telescope.actions').select_horizontal,
            ['t'] = require('telescope.actions').select_tab,
            ['cd'] = setCWDtoPicker,
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
    vim.keymap.set('n', '<leader>ff', function()
      builtin.find_files { no_ignore = false }
    end, { desc = '[F]ind [F]iles' })
    vim.keymap.set('n', '<leader>sj', function()
      builtin.find_files { no_ignore = false, cwd = getCWD(), prompt_title = 'Find files (cwd)' }
    end, { desc = '[F]ind [F]iles (cwd)' })
    vim.keymap.set('n', '<leader>sf', function()
      builtin.find_files { no_ignore = false, cwd = getCWD(), prompt_title = 'Find files (cwd)' }
    end, { desc = '[F]ind [F]iles (cwd)' })
    vim.keymap.set('n', '<leader>h', function()
      builtin.find_files { no_ignore = false }
    end, { desc = '[F]ind [F]iles' })
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
    vim.keymap.set('n', '<leader>fC', builtin.commands, { desc = '[F]ind [C]ommands' })
    vim.keymap.set('n', '<leader>fw', builtin.live_grep, { desc = '[F]ind [W]ord' })
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
    vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = '[F]ind Recent' })
    vim.keymap.set('n', 'su', builtin.oldfiles, { silent = true, desc = '[F]ind Recent' })
    vim.keymap.set('n', 'si', function()
      builtin.find_files { silent = true, no_ignore = false }
    end, { desc = '[F]ind [F]iles' })
    vim.keymap.set('n', '<leader>j', builtin.oldfiles, { desc = '[F]ind Recent' })
    vim.keymap.set('n', '<leader>fj', builtin.oldfiles, { desc = '[F]ind Recent' })
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
    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>fj', function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        -- winblend = 10,
        previewer = true,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

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
