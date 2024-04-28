local bufname = vim.api.nvim_buf_get_name(0)
cmd = 'python3 ' .. bufname
vim.api.nvim_buf_set_option(0, 'makeprg', cmd)
