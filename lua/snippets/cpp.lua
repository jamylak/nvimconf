local ls = require 'luasnip' -- Load LuaSnip

local fmta = require('luasnip.extras.fmt').fmta

local s = ls.snippet
local i = ls.insert_node

ls.add_snippets('cpp', {
  s(
    'fi',
    fmta(
      [[
int <fname>(<args>) {
  return <ret>
}
]],
      {
        fname = i(1),
        args = i(2),
        ret = i(3),
      }
    )
  ),
})
