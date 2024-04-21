return {
  'folke/which-key.nvim',
  keys = { '<leader>', 'a', 'c', 'g', 'h', 'l', 'n', 'o', 'p', 'q', 'r', 's', 'u', 'v', 'x', 'y', 'z', ']', '[', '=' },
  config = function() -- This is the function that runs, AFTER loading
    require('which-key').setup {
      triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for keymaps that start with a native binding
        i = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'f', 'i', '9', '8', 'w', 'd' },
        n = { 'w', 'W', 'b', 'B' },
        v = { 'j', 'k' },
      },
    }

    -- Document existing key chains
    require('which-key').register {
      ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
      ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
      ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
      ['<leader>f'] = { name = '[F]ind', _ = 'which_key_ignore' },
      ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
    }
  end,
}
