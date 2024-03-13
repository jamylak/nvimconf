return {
  'jamylak/nvim-github-codesearch',
  build = 'make',
  branch = 'fix/build',
  keys = {
    { '<leader>sg', ':lua require"nvim-github-codesearch".prompt()<CR>' },
  },
  opts = {
    github_auth_token = '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',
    use_telescope = true,
  },
}
