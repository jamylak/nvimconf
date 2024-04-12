local ls = require 'luasnip' -- Load LuaSnip

local fmta = require('luasnip.extras.fmt').fmta
-- local rep = require('luasnip.extras').rep

local s = ls.snippet
local i = ls.insert_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local sn = ls.snippet_node

ls.add_snippets('python', {
  s(
    'f',
    fmta(
      [[
def <fname>(<args>):
  return <ret>
]],
      {
        fname = i(1),
        args = i(2),
        ret = i(3),
      }
    )
  ),
})
