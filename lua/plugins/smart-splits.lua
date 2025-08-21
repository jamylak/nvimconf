-- TODO: Make some defaults for when there are no other
-- windows (or kitty windows?) open... eg. it could do something
-- useful on a-j or a-k
return {
  'mrjones2014/smart-splits.nvim',
  build = './kitty/install-kittens.bash',
  keys = {
    -- recommended mappings
    -- resizing splits
    -- these keymaps will also accept a range,
    -- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
    {
      '<A-h>',
      function()
        require('smart-splits').resize_left()
      end,
    },
    {
      '<A-j>',
      function()
        require('smart-splits').resize_down()
      end,
    },
    {
      '<A-k>',
      function()
        require('smart-splits').resize_up()
      end,
    },
    {
      '<A-l>',
      function()
        require('smart-splits').resize_right()
      end,
    },
    -- swapping buffers between windows
    {
      '<leader><leader>h',
      function()
        require('smart-splits').swap_buf_left()
      end,
    },
    {
      '<leader><leader>j',
      function()
        require('smart-splits').swap_buf_down()
      end,
    },
    {
      '<leader><leader>k',
      function()
        require('smart-splits').swap_buf_up()
      end,
    },
    {
      '<leader><leader>l',
      function()
        require('smart-splits').swap_buf_right()
      end,
    },
  },
  opts = {
    default_amount = 8,
  },
}
