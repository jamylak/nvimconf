return {
  'hrsh7th/nvim-cmp',
  event = 'VeryLazy',
  dependencies = {
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

    'onsails/lspkind.nvim',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lsp',
    -- 'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-path',
    -- 'hrsh7th/cmp-buffer',

    'rafamadriz/friendly-snippets',
  },
  config = function()
    -- See `:help cmp`
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    local lspkind = require 'lspkind'
    luasnip.config.setup {}
    local super = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm { select = true }
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' })
    local superBack = cmp.mapping(function(fallback)
      if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' })
    require 'snippets'
    -- require('luasnip.loaders.from_vscode').lazy_load { paths = { './snippets' } }

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    -- cmp.setup.cmdline(':', {
    --   mapping = cmp.mapping.preset.cmdline(),
    --   sources = cmp.config.sources({
    --     { name = 'cmdline', keyword_length = 5 },
    --   }, {
    --     { name = 'path', keyword_length = 5 },
    --   }),
    -- })
    -- could reenable this if i can disable tab and only tab native
    -- or find way eg. start typing ne and it has good completion

    -- cmp.setup.cmdline('/', {
    --   mapping = cmp.mapping.preset.cmdline(),
    --   sources = {
    --     { name = 'buffer' },
    --   },
    -- })

    cmp.setup {
      formatting = {
        fields = { 'abbr', 'kind', 'menu' },
        expandable_indicator = true,
        format = lspkind.cmp_format {
          mode = 'symbol', -- show only symbol annotations
          maxwidth = 50,   -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          -- can also be a function to dynamically calculate max width such as
          -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
          ellipsis_char = '...',    -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          show_labelDetails = true, -- show labelDetails in menu. Disabled by default

          -- The function below will be called before any actual modifications from lspkind
          -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
          -- before = function (entry, vim_item)
          --   return vim_item
          -- end
          with_text = true,
          menu = {
            nvim_lsp = '[LSP]',
            luasnip = '[LuaSnip]',
            path = '[Path]',
          },
        },
      },

      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = 'menu,menuone,noinsert' },

      -- For an understanding of why these mappings were
      -- chosen, you will need to read `:help ins-completion`
      mapping = cmp.mapping.preset.insert {
        ['<C-b>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.scroll_docs(-4)
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<C-f>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.scroll_docs(4)
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<C-e>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.close()
          end
          fallback()
        end, { 'i', 's' }),
        ['<C-n>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Down>", true, false, true), "t", true)
          end
        end, { 'i', 's' }),
        ['<C-p>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            print('visible')
            cmp.select_prev_item()
          else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Up>", true, false, true), "t", true)
            -- fallback()
          end
        end, { 'i', 's' }),
        ['<C-y>'] = cmp.mapping.confirm { select = true },
        -- Manually trigger a completion from nvim-cmp.
        --  Generally you don't need this, because nvim-cmp will display
        --  completions whenever it has completion options available.
        ['<C-space>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.close()
          else
            cmp.complete()
          end
        end, { 'i', 's' }),
        ['<C-l>'] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { 'i', 's' }),
        ['<C-h>'] = cmp.mapping(function(fallback)
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<backspace>', true, true, true), 'n', true)
          end
        end, { 'i', 's' }),
        ['JH'] = superBack,
        ['jh'] = superBack,
        ['JJ'] = super,
        ['JI'] = super,
        ['JK'] = cmp.mapping.select_next_item(),
        ['jj'] = super,
        ['<C-j>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm { select = true }
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            -- fallback()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, true, true), 'n', true)
          end
        end, { 'i', 's' }),
        ['<C-k>'] = cmp.mapping(function(fallback)
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      sources = {
        { name = 'luasnip' },
        {
          name = 'nvim_lsp',
          -- https://stackoverflow.com/questions/73092651/neovim-how-to-filter-out-text-snippets-from-nvim-lspconfig-nvim-cmp
          -- Filter only for lua?
          entry_filter = function(entry, ctx)
            return require('cmp').lsp.CompletionItemKind.Text ~= entry:get_kind()
          end,
        },
        { name = 'path', option = {
          get_cwd = function(param)
            local proj_root_ft = { gitcommit = true, octo = true, NeogitCommitMessage = true }
            -- TODO: Is there a smart way to handle project root vs
            -- /root? Maybe /is always project root? but how to get
            -- / system root then?
            if proj_root_ft[param.context.filetype] then
              -- Otherwise eg. neogit is inside .git and cwd is not correct
              return vim.fn.getcwd()
            end
            return vim.fn.expand '%:p:h'
          end },
        }
      },
    }
    cmp.setup.filetype('sql', {
      sources = {
        { name = 'vim-dadbod-completion' },
        { name = 'buffer' },
      },
    })
  end,
}
