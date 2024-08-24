local ls = require 'luasnip' -- Load LuaSnip

local fmta = require('luasnip.extras.fmt').fmta

local s = ls.snippet
local i = ls.insert_node

ls.add_snippets('glsl', {
  s('v2', fmta('vec2 ', {})),
  s(
    'vk',
    fmta('vec2(<a>.<b>, <c>.<d>);', {
      a = i(1),
      b = i(2),
      c = i(3),
      d = i(4),
    })
  ),
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
