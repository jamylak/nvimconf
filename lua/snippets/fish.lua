local ls = require 'luasnip' -- Load LuaSnip

local fmta = require('luasnip.extras.fmt').fmta

local s = ls.snippet
local i = ls.insert_node

ls.add_snippets('fish', {
  s(
    'a',
    fmta(
      [[
abbr -a <abbr> "<cmd>"
]],
      {
        abbr = i(1),
        cmd = i(2),
      }
    )
  ),
})
