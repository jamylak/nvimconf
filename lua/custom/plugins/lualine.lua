return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'folke/trouble.nvim',
  },
  opts = function(_, opts)
    local trouble = require 'trouble'
    local symbols = trouble.statusline {
      mode = 'lsp_document_symbols',
      groups = {},
      title = false,
      filter = { range = true },
      format = '{kind_icon}{symbol.name:Normal}',
    }
    opts.sections = { lualine_c = { 'filename' } }
    table.insert(opts.sections.lualine_c, {
      symbols.get,
      cond = symbols.has,
    })
  end,
}
