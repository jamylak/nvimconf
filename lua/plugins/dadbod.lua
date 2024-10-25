return {
  {
    'tpope/vim-dadbod',
    cmd = { 'DBUI', 'DB', 'DBUIToggle', 'DBUIFindBuffer', 'DBUIRenameBuffer' },
    dependencies = {
      { 'kristijanhusak/vim-dadbod-completion', event = 'InsertEnter' },
      { 'kristijanhusak/vim-dadbod-ui', cmd = { 'DBUI', 'DBUIToggle', 'DBUIFindBuffer', 'DBUIRenameBuffer' } },
    },
    config = function()
      -- Optional configuration can go here
    end,
  },
}
