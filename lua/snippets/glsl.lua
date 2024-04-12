local ls = require 'luasnip' -- Load LuaSnip

local fmta = require('luasnip.extras.fmt').fmta

local s = ls.snippet
local i = ls.insert_node

ls.add_snippets('glsl', {
  s(
    'v',
    fmta('vec3 <name> = vec3(<args>);', {
      name = i(1),
      args = i(2),
    })
  ),
  s(
    'vv',
    fmta(' vec2 <name> = vec2(<args>);', {
      name = i(1),
      args = i(2),
    })
  ),
  s(
    'vf',
    fmta(
      [[
vec3 <fname>(<args>) {
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
