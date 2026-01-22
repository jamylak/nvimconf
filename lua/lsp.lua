local function setup_lsp_keymaps()
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('hardcoded-lsp-attach', { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
      map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
      map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
      map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
      map('<leader>sd', require('telescope.builtin').lsp_document_symbols, '[S]ymbols: [D]ocument ')
      map('<leader>d', require('telescope.builtin').lsp_document_symbols, '[S]ymbols: [D]ocument ')
      map('<leader>ss', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[S]ymbols: [W]orkspace')
      map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
      map('<leader>lr', vim.lsp.buf.rename, '[R]e[n]ame')
      map('K', vim.lsp.buf.hover, 'Hover Documentation')
      map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          callback = vim.lsp.buf.clear_references,
        })
      end
    end,
  })
end

local function build_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.offsetEncoding = { 'utf-8' }
  local ok, cmp = pcall(require, 'cmp_nvim_lsp')
  if ok then
    capabilities = vim.tbl_deep_extend('force', capabilities, cmp.default_capabilities())
  end
  return capabilities
end

local function default_root(bufnr, markers)
  return vim.fs.root(bufnr, markers) or vim.fn.getcwd()
end

local function setup_hardcoded_servers()
  local capabilities = build_capabilities()
  local missing = {}

  local function get_clients(opts)
    if vim.lsp.get_clients then
      return vim.lsp.get_clients(opts or {})
    end
    local clients = vim.lsp.get_active_clients()
    if not opts or not opts.bufnr then
      return clients
    end
    local filtered = {}
    for _, client in ipairs(clients) do
      if client.attached_buffers and client.attached_buffers[opts.bufnr] then
        table.insert(filtered, client)
      end
    end
    return filtered
  end

  local servers = {
    {
      name = 'zls',
      cmd = { 'zls' },
      filetypes = { 'zig' },
      root_markers = { 'build.zig', '.git' },
    },
    {
      name = 'ty',
      cmd = { 'ty' },
      filetypes = { 'python' },
      root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
    },
    {
      name = 'clangd',
      cmd = { 'clangd' },
      filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
      root_markers = { 'compile_commands.json', 'compile_flags.txt', '.git' },
    },
    {
      name = 'lua_ls',
      cmd = { 'lua-language-server' },
      filetypes = { 'lua' },
      root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
      settings = {
        Lua = {
          completion = { callSnippet = 'Replace' },
        },
      },
    },
    {
      name = 'rust_analyzer',
      cmd = { 'rust-analyzer' },
      filetypes = { 'rust' },
      root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
    },
    {
      name = 'yamlls',
      cmd = { 'yaml-language-server', '--stdio' },
      filetypes = { 'yaml', 'yml' },
      root_markers = { '.git' },
    },
    {
      name = 'jsonls',
      cmd = { 'vscode-json-language-server', '--stdio' },
      filetypes = { 'json', 'jsonc' },
      root_markers = { 'package.json', '.git' },
    },
  }

  local function start_for_buf(bufnr)
    local ft = vim.bo[bufnr].filetype
    if ft == nil or ft == '' then
      return
    end

    for _, server in ipairs(servers) do
      if vim.tbl_contains(server.filetypes or {}, ft) then
        if vim.fn.executable(server.cmd[1]) ~= 1 then
          if not missing[server.name] then
            missing[server.name] = true
            vim.schedule(function()
              vim.notify('LSP not found in PATH: ' .. server.cmd[1], vim.log.levels.WARN)
            end)
          end
          return
        end

        vim.lsp.start({
          name = server.name,
          cmd = server.cmd,
          root_dir = default_root(bufnr, server.root_markers or { '.git' }),
          settings = server.settings,
          init_options = server.init_options,
          capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {}),
        }, { bufnr = bufnr })
      end
    end
  end

  local group = vim.api.nvim_create_augroup('hardcoded-lsp-start', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    callback = function(args)
      start_for_buf(args.buf)
    end,
  })

  vim.api.nvim_create_user_command('LspInfo', function()
    local clients = get_clients()
    local lines = { 'Active LSP clients:' }
    if #clients == 0 then
      lines = { 'No active LSP clients' }
    else
      for _, client in ipairs(clients) do
        local root = client.config and client.config.root_dir or ''
        local cmd = client.config and client.config.cmd and table.concat(client.config.cmd, ' ') or ''
        table.insert(lines, string.format('- %s (id=%d) root=%s cmd=%s', client.name, client.id, root, cmd))
      end
    end
    vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO)
  end, {})

  vim.api.nvim_create_user_command('LspRestart', function()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = get_clients({ bufnr = bufnr })
    for _, client in ipairs(clients) do
      client.stop()
    end
    vim.defer_fn(function()
      start_for_buf(bufnr)
    end, 100)
  end, {})

  vim.api.nvim_create_user_command('LspStart', function()
    start_for_buf(vim.api.nvim_get_current_buf())
  end, {})
end

setup_lsp_keymaps()
setup_hardcoded_servers()
