vim.api.nvim_create_user_command('KittyRunUVRight', function()
  local filename = vim.api.nvim_buf_get_name(0)
  if filename == '' then
    print 'No file to run.'
    return
  end
  -- TODO: Fix space issues in path
  -- TODO: Move to some fish functions which handle some of these issues
  -- Make sure to send the text so it can be in the history and easily repeated
  local cmd = string.format(
    "fish -c 'set id $(kitty @ launch --location=vsplit --cwd=%s --type=window --dont-take-focus fish); kitty @ send-text --match=id:$id \"uv run %s\n\"'",
    vim.fn.getcwd(),
    filename
  )
  os.execute(cmd)
end, { desc = "Open Kitty window right and run 'uv run filename.py' in nvim cwd" })
