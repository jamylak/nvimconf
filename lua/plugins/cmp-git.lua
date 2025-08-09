return {
  'petertriho/cmp-git', -- optional - Git completion
  ft = { "gitcommit", "octo", "NeogitCommitMessage" },
  config = function()
    require('cmp_git').setup {}
    table.insert(require("cmp").get_config().sources, { name = "git" })
  end
}
