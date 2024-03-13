return { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    module=false,
    lazy=true,
    dependencies = {
      -- 'nvim-treesitter/playground',
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-context',
    },
    build = ':TSUpdate',
    config = function()
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        autotag = { enable = true },
        ensure_installed = { 'bash', 'c', 'python', 'html', 'lua', 'markdown', 'vim', 'vimdoc' },
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = { enable = true },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['ak'] = { query = '@block.outer', desc = 'around block' },
              ['ik'] = { query = '@block.inner', desc = 'inside block' },
              ['ac'] = { query = '@class.outer', desc = 'around class' },
              ['ic'] = { query = '@class.inner', desc = 'inside class' },
              ['ae'] = { query = '@expression', desc = 'around expression', query_group = 'expression' },
              ['ie'] = { query = '@expression', desc = 'inside expression', query_group = 'expression' },
              ['au'] = { query = '@call.outer', desc = 'around call expression' },
              ['iu'] = { query = '@call.inner', desc = 'inside call expression' },
              -- TODO: figure out how to do this since it's not builtin
              -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects?tab=readme-ov-file#overriding-or-extending-textobjects
              -- ['av'] = { query = '@value.outer', desc = 'around value' },
              -- ['iv'] = { query = '@value.inner', desc = 'inside value' },
              ['a?'] = { query = '@conditional.outer', desc = 'around conditional' },
              ['i?'] = { query = '@conditional.inner', desc = 'inside conditional' },
              ['af'] = { query = '@function.outer', desc = 'around function ' },
              ['if'] = { query = '@function.inner', desc = 'inside function ' },
              ['al'] = { query = '@loop.outer', desc = 'around loop' },
              ['il'] = { query = '@loop.inner', desc = 'inside loop' },
              ['aa'] = { query = '@parameter.outer', desc = 'around argument' },
              ['ia'] = { query = '@parameter.inner', desc = 'inside argument' },
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              [']c'] = { query = '@class.outer', desc = 'Next class start' },
              [']k'] = { query = '@block.outer', desc = 'Next block start' },
              [']f'] = { query = '@function.outer', desc = 'Next function start' },
              [']a'] = { query = '@parameter.inner', desc = 'Next argument start' },
            },
            goto_next_end = {
              [']C'] = { query = '@class.outer', desc = 'Next class end' },
              [']K'] = { query = '@block.outer', desc = 'Next block end' },
              [']F'] = { query = '@function.outer', desc = 'Next function end' },
              [']A'] = { query = '@parameter.inner', desc = 'Next argument end' },
            },
            goto_previous_start = {
              ['[c'] = { query = '@class.outer', desc = 'Previous class start' },
              ['[k'] = { query = '@block.outer', desc = 'Previous block start' },
              ['[f'] = { query = '@function.outer', desc = 'Previous function start' },
              ['[a'] = { query = '@parameter.inner', desc = 'Previous argument start' },
            },
            goto_previous_end = {
              ['[C'] = { query = '@class.outer', desc = 'Previous class end' },
              ['[F'] = { query = '@function.outer', desc = 'Previous function end' },
              ['[A'] = { query = '@parameter.inner', desc = 'Previous argument end' },
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['>C'] = { query = '@class.outer', desc = 'Swap next class' },
              ['>K'] = { query = '@block.outer', desc = 'Swap next block' },
              ['>F'] = { query = '@function.outer', desc = 'Swap next function' },
              ['>A'] = { query = '@parameter.inner', desc = 'Swap next argument' },
            },
            swap_previous = {
              ['<C'] = { query = '@class.outer', desc = 'Swap previous class' },
              ['<K'] = { query = '@block.outer', desc = 'Swap previous block' },
              ['<F'] = { query = '@function.outer', desc = 'Swap previous function' },
              ['<A'] = { query = '@parameter.inner', desc = 'Swap previous argument' },
            },
          },
        },
      }

      local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'
      -- Repeat movement with ; and ,
      -- vim way: ; goes to the direction you were moving.
      vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move)
      vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_opposite)

      -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
      vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f)
      vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F)
      vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t)
      vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T)

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
      --
      require('treesitter-context').setup {
        -- enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
        -- min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        -- line_numbers = true,
        -- multiline_threshold = 20, -- Maximum number of lines to show for a single context
        -- trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        -- mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- -- Separator between context and content. Should be a single character string, like '-'.
        -- -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        -- separator = nil,
        -- zindex = 20, -- The Z-index of the context window
        -- on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      }
    end,
  }
