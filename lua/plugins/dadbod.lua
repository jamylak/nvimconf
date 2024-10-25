return {
  {
    'tpope/vim-dadbod',
    cmd = { 'DBUI', 'DB', 'DBUIToggle', 'DBUIFindBuffer', 'DBUIRenameBuffer' },
    dependencies = {
      { 'kristijanhusak/vim-dadbod-completion', cmd = { 'DBUI', 'DBUIToggle', 'DBUIFindBuffer', 'DBUIRenameBuffer' } },
      { 'kristijanhusak/vim-dadbod-ui', cmd = { 'DBUI', 'DBUIToggle', 'DBUIFindBuffer', 'DBUIRenameBuffer' } },
    },
    config = function()
      -- Optional configuration can go here
    end,
  },
}
