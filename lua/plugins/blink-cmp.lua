return {
  'saghen/blink.cmp',
  version = '1.*',
  event = 'VeryLazy',
  dependencies = {
    {
      'saghen/blink.compat',
      version = '2.*',
      lazy = true,
      opts = {},
    },
    {
      'L3MON4D3/LuaSnip',
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
    },
    'rafamadriz/friendly-snippets',
  },
  opts = {
    keymap = {
      preset = 'none',
      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-e>'] = { 'hide', 'fallback' },
      ['<C-n>'] = {
        'select_next',
        function()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Down>', true, false, true), 'n', true)
          return true
        end,
      },
      ['<C-p>'] = {
        'select_prev',
        function()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Up>', true, false, true), 'n', true)
          return true
        end,
      },
      ['<C-y>'] = { 'select_and_accept' },
      ['<C-space>'] = { 'hide', 'show' },
      ['<C-l>'] = { 'snippet_forward', 'fallback' },
      ['<C-h>'] = { 'snippet_backward', 'fallback' },
      ['JH'] = { 'snippet_backward', 'fallback' },
      ['jh'] = { 'snippet_backward', 'fallback' },
      ['JJ'] = { 'select_and_accept', 'snippet_forward', 'fallback' },
      ['JI'] = { 'select_and_accept', 'snippet_forward', 'fallback' },
      ['JK'] = { 'select_next', 'fallback' },
      ['jj'] = { 'select_and_accept', 'snippet_forward', 'fallback' },
      ['<C-j>'] = { 'select_and_accept', 'snippet_forward', 'fallback' },
      ['<C-k>'] = { 'snippet_forward', 'fallback' },
    },
    snippets = { preset = 'luasnip' },
    completion = {
      list = {
        selection = {
          preselect = false,
          auto_insert = false,
        },
      },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets' },
      per_filetype = {
        lua = { inherit_defaults = true, 'lazydev' },
        sql = { 'dadbod', 'buffer' },
        gitcommit = { inherit_defaults = true, 'git' },
        octo = { inherit_defaults = true, 'git' },
        NeogitCommitMessage = { inherit_defaults = true, 'git' },
        ['dap-repl'] = { 'dap' },
        dapui_watches = { 'dap' },
        dapui_hover = { 'dap' },
      },
      providers = {
        lazydev = { name = 'lazydev', module = 'lazydev.integrations.blink' },
        dap = { name = 'dap', module = 'blink.compat.source' },
        git = { name = 'git', module = 'blink.compat.source' },
        dadbod = { name = 'dadbod', module = 'vim_dadbod_completion.blink' },
      },
    },
  },
  config = function(_, opts)
    local luasnip = require 'luasnip'
    luasnip.config.setup {}
    require 'snippets'
    require('luasnip.loaders.from_vscode').lazy_load { paths = { vim.fn.stdpath("config") .. "/lua/snippets" } }

    require('blink.cmp').setup(opts)
  end,
}
