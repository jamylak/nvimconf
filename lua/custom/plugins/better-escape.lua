return {
  'max397574/better-escape.nvim',
  opts = {
    mapping = { 'ji', 'jk', 'jj', 'ko' }, -- a table with mappings to use
    timeout = 100, -- the time in which the keys must be hit in ms.
    clear_empty_lines = false, -- clear line after escaping if there is only whitespace
    keys = '<Esc>', -- keys used for escaping, if it is a function will use the result everytime
  },
}
