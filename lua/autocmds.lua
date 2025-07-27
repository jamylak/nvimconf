-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
-- No line numbers in terminal buffers
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = 'term://*',
  callback = function()
    -- setlocal nonumber norelativenumber
    vim.cmd 'setlocal nonumber norelativenumber'
  end,
})
vim.api.nvim_create_autocmd('TermClose', {
  pattern = 'term://*',
  command = "lua vim.api.nvim_input('<CR>')",
})

-- Only load treesitter after the first buffer is loaded
-- to try and avoid some delays
-- vim.api.nvim_create_autocmd('BufReadPost', {
--   pattern = '*',
--   once = true,
--   callback = function()
--     -- TODO: Fix the pattern and only run once
--     vim.defer_fn(function()
--       vim.cmd 'Lazy load nvim-treesitter nvim-lspconfig'
--       vim.cmd 'LspStart'
--     end, 100)
--   end,
-- })

vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*.frag,*.vert,*.tesc,*.tese,*.geom,*.comp',
  command = 'set filetype=glsl',
})
-- Don't have a good metal one yet
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*.metal',
  command = 'set filetype=glsl',
})

-- Auto-cd to git root if Neovim is launched with a file
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local utils = require 'utils'
    local argv = vim.fn.argv()
    if #argv > 0 then
      local file = argv[1]
      local path = vim.fn.fnamemodify(file, ':p:h')

      -- print('Auto-cd to git root for path: ' .. path)
      utils.tcd_to_git_root(path)
    end
  end,
})
