-- Needs to be mapped like this otherwise c-[ will activate escape
-- if done in textobjects keymaps
vim.api.nvim_set_keymap('n', '<c-[>', '[a', { silent = true })
vim.api.nvim_set_keymap('n', '<c-]>', ']a', { silent = true })
return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  dependencies = {
    'nvim-treesitter/playground',
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
            ['mai'] = { query = '@assignment.inner', desc = '@assignment.inner' },
            ['mao'] = { query = '@assignment.outer', desc = '@assignment.outer' },
            ['mal'] = { query = '@assignment.lhs', desc = '@assignment.lhs' },
            ['mar'] = { query = '@assignment.rhs', desc = '@assignment.rhs' },
            ['mj'] = { query = '@assignment.lhs', desc = '@assignment.lhs' },
            ['mk'] = { query = '@assignment.rhs', desc = '@assignment.rhs' },
            ['mti'] = { query = '@attribute.inner', desc = '@attribute.inner' },
            ['mto'] = { query = '@attribute.outer', desc = '@attribute.outer' },
            ['mbi'] = { query = '@block.inner', desc = '@block.inner' },
            ['mbo'] = { query = '@block.outer', desc = '@block.outer' },
            ['mli'] = { query = '@call.inner', desc = '@call.inner' },
            ['mlo'] = { query = '@call.outer', desc = '@call.outer' },
            -- I don't think comment inner works, check support table in github
            -- ['m/i'] = { query = '@comment.inner', desc = '@comment.inner' },
            ['m/o'] = { query = '@comment.outer', desc = '@comment.outer' },
            ['m/i'] = { query = '@comment.inner', desc = '@comment.inner' },
            ['m?i'] = { query = '@conditional.inner', desc = '@conditional.inner' },
            ['m?o'] = { query = '@conditional.outer', desc = '@conditional.outer' },
            ['mfi'] = { query = '@frame.inner', desc = '@frame.inner' },
            ['mfo'] = { query = '@frame.outer', desc = '@frame.outer' },
            ['moi'] = { query = '@loop.inner', desc = '@loop.inner' },
            ['moo'] = { query = '@loop.outer', desc = '@loop.outer' },
            ['mn'] = { query = '@number.inner', desc = '@number.inner' },
            ['mxi'] = { query = '@regex.inner', desc = '@regex.inner' },
            ['mxo'] = { query = '@regex.outer', desc = '@regex.outer' },
            ['mri'] = { query = '@return.inner', desc = '@return.inner' },
            ['mro'] = { query = '@return.outer', desc = '@return.outer' },
            ['mpi'] = { query = '@scopename.inner', desc = '@scopename.inner' },
            ['msi'] = { query = '@statement.inner', desc = '@statement.inner' },

            ['aU'] = { query = '@block.outer', desc = 'around block' },
            ['iU'] = { query = '@block.inner', desc = 'inside block' },
            ['ac'] = { query = '@class.outer', desc = 'around class' },
            ['ic'] = { query = '@class.inner', desc = 'inside class' },
            -- TODO: figure out how to do this since it's not builtin
            -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects?tab=readme-ov-file#overriding-or-extending-textobjects
            -- ['av'] = { query = '@value.outer', desc = 'around value' },
            -- ['iv'] = { query = '@value.inner', desc = 'inside value' },
            ['a?'] = { query = '@conditional.outer', desc = 'around conditional' },
            ['i?'] = { query = '@conditional.inner', desc = 'inside conditional' },
            ['af'] = { query = '@function.outer', desc = 'around function ' },
            ['if'] = { query = '@function.inner', desc = 'inside function ' },
            ['al'] = { query = '@loop.outer', desc = 'around loop' },
            ['iL'] = { query = '@loop.inner', desc = 'inside loop' },
            ['aa'] = { query = '@parameter.outer', desc = 'around argument' },
            ['ia'] = { query = '@parameter.inner', desc = 'inside argument' },
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']s'] = { query = '@assignment.outer', desc = 'Next assignment outer' },
            [']S'] = { query = '@assignment.inner', desc = 'Next assignment inner' },
            [']?'] = { query = '@conditional.outer', desc = 'Next conditional start' },
            [']/'] = { query = '@comment.outer', desc = 'Next comment start' },
            [']l'] = { query = '@call.outer', desc = 'Next call outer' },
            [']L'] = { query = '@call.inner', desc = 'Next call inner' },
            [']o'] = { query = '@loop.outer', desc = 'Next loop outer' },
            [']n'] = { query = '@number.inner', desc = 'Next number outer' },
            ['];'] = { query = '@return.outer', desc = 'Next return outer' },
            [']c'] = { query = '@class.outer', desc = 'Next class outer' },
            [']C'] = { query = '@class.inner', desc = 'Next class inner' },
            -- usually only block outer works
            [']k'] = { query = '@block.outer', desc = 'Next block inner' },
            -- [']K'] = { query = '@block.outer', desc = 'Next block outer' },
            [']f'] = { query = '@function.outer', desc = 'Next function outer' },
            [']F'] = { query = '@function.inner', desc = 'Next function inner' },
            [']a'] = { query = '@parameter.inner', desc = 'Next argument inner' },
            -- ['<c-]>'] = { query = '@parameter.inner', desc = 'Next argument inner' },
            -- [']A'] = { query = '@parameter.outer', desc = 'Next argument outer' },
          },
          goto_next_end = {
            [']='] = { query = '@assignment.inner', desc = 'Next assignment inner end' },
            ['])'] = { query = '@call.inner', desc = 'Next call inner end' },
            [']('] = { query = '@call.inner', desc = 'Next call inner end' },
            [']O'] = { query = '@loop.inner', desc = 'Next loop inner end' },
            [']{'] = { query = '@class.outer', desc = 'Next class outer end' },
            [']}'] = { query = '@class.outer', desc = 'Next class outer end' },
            [']]'] = { query = '@block.inner', desc = 'Next block inner end' },
            [']K'] = { query = '@block.outer', desc = 'Next block end' },
            [']:'] = { query = '@function.inner', desc = 'Next function end' },
            [']m'] = { query = '@function.outer', desc = 'Next function end' },
            [']A'] = { query = '@parameter.inner', desc = 'Next argument end' },
          },
          goto_previous_start = {
            ['[s'] = { query = '@assignment.outer', desc = 'Previous assignment outer' },
            ['[S'] = { query = '@assignment.inner', desc = 'Previous assignment inner' },
            ['[='] = { query = '@assignment.outer', desc = 'Previous assignment outer' },
            ['[?'] = { query = '@conditional.outer', desc = 'Previous conditional start' },
            ['[l'] = { query = '@call.outer', desc = 'Previous call outer' },
            ['[L'] = { query = '@call.inner', desc = 'Previous call inner' },
            ['[o'] = { query = '@loop.outer', desc = 'Previous loop outer' },
            ['[n'] = { query = '@number.inner', desc = 'Previous number outer' },
            ['[;'] = { query = '@return.outer', desc = 'Previous return outer' },
            ['[c'] = { query = '@class.outer', desc = 'Previous class outer' },
            ['[C'] = { query = '@class.inner', desc = 'Previous class inner' },
            ['[k'] = { query = '@block.outer', desc = 'Previous block start' },
            ['[f'] = { query = '@function.outer', desc = 'Previous function outer' },
            ['[F'] = { query = '@function.inner', desc = 'Previous function inner' },
            ['[a'] = { query = '@parameter.inner', desc = 'Previous argument start' },
            -- ['<c-[>'] = { query = '@parameter.inner', desc = 'Previous argument start' },
          },
          goto_previous_end = {
            ['[)'] = { query = '@call.inner', desc = 'Previous call inner' },
            ['[('] = { query = '@call.inner', desc = 'Previous call inner' },
            ['[='] = { query = '@assignment.inner', desc = 'Previous assignment inner' },
            ['[O'] = { query = '@loop.inner', desc = 'Previous loop inner' },
            ['[K'] = { query = '@block.outer', desc = 'Previous block end' },
            ['[{'] = { query = '@class.outer', desc = 'Previous class end' },
            ['[}'] = { query = '@class.outer', desc = 'Previous class end' },
            ['[:'] = { query = '@function.inner', desc = 'Previous function end' },
            ['[m'] = { query = '@function.outer', desc = 'Previous function end' },
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

    local function cinaIntToString(i)
      -- Because next is the one after cia
      -- it will start at 2nd which is just cina
      -- then 3rd is c3ina
      return i == 2 and '' or tostring(i)
    end
    local function cilaIntToString(i)
      -- cila is just last one and c2ila is 2nd last
      return i == 1 and '' or tostring(i)
    end

    -- Change next arg powered by treesitter
    -- Works as long as you are not right at the end of an ar
    -- eg. cina = change next arg (after the normal cia)
    -- c3ina = change n'th arg eg. 3rd arg
    -- cila = change last arg (if in cursor then before that)
    -- c2ila = change 2nd last arg
    for i = 1, 9 do
      vim.keymap.set('n', 'c' .. cinaIntToString(i + 1) .. 'ina', ':normal ]A' .. string.rep(']a', i) .. 'cia<CR>', { silent = true })
      vim.keymap.set('n', 'c' .. cinaIntToString(i + 1) .. 'ana', ':normal ]A' .. string.rep(']a', i) .. 'caa<CR>', { silent = true })
    end
    for i = 1, 9 do
      vim.keymap.set('n', 'c' .. cilaIntToString(i) .. 'ila', ':normal ' .. string.rep('[A', i) .. 'cia<CR>', { silent = true })
      vim.keymap.set('n', 'c' .. cilaIntToString(i) .. 'ala', ':normal ' .. string.rep('[A', i) .. 'caa<CR>', { silent = true })
    end

    -- New function / call argument, only works with existing args
    -- TODO: Maybe seperate new call argument, or way to make new 1st or 2nd arg
    -- in either case
    -- Make a new argument, go in function, go to last arg, create comma in insert mode
    vim.keymap.set('n', 'cinFA', function()
      vim.cmd 'normal ]F[Aa, '
      vim.cmd 'normal l'
      vim.cmd 'startinsert'
    end, { silent = true })
    -- New function first param
    vim.keymap.set('n', 'cinFF', function()
      -- Go inside function then outside function to make it more reliable
      vim.cmd 'normal ]F[f]ai, '
      vim.cmd 'normal h'
      vim.cmd 'startinsert'
    end, { silent = true })
    -- New call argument
    vim.keymap.set('n', 'cinCA', function()
      vim.cmd 'normal ])a, '
      vim.cmd 'normal l'
      vim.cmd 'startinsert'
    end, { silent = true })
    -- New call argument first param
    vim.keymap.set('n', 'cinCF', function()
      -- Go into call then outside to make it more reliable
      vim.cmd 'normal ])[l]ai, '
      vim.cmd 'normal h'
      vim.cmd 'startinsert'
    end, { silent = true })

    local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'
    -- Repeat movement with ; and ,
    -- vim way: ; goes to the direction you were moving.
    vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move)
    vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_opposite)

    -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
    vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f)
    vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F)
    -- vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t)
    -- vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T)

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
