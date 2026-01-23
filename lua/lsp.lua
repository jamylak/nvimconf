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
      map('<leader>d', require('telescope.builtin').lsp_document_symbols, '[S]ymbols: [D]ocument ')
      map('<leader>ss', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[S]ymbols: [W]orkspace')
      map('<leader>sd', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[S]ymbols: [W]orkspace')
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
  local root = vim.fs.root(bufnr, markers)
  if root then
    return root
  end
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name ~= '' then
    return vim.fn.fnamemodify(name, ':p:h')
  end
  return vim.fn.getcwd()
end

local function setup_hardcoded_servers()
  local capabilities = build_capabilities()
  local missing = {}
  local function notify_missing(server, bin)
    if vim.g.hardcoded_lsp_notify_missing == false then
      return
    end
    local msg = 'LSP not found in PATH: ' .. bin
    if server.install_hint then
      msg = msg .. ' — ' .. server.install_hint
    end
    vim.notify(msg, vim.log.levels.WARN, { title = 'LSP Missing', timeout = 3000 })
  end

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
      filetypes = { 'zig', 'zir' },
      root_markers = { 'zls.json', 'build.zig', '.git' },
      install_hint = 'Install: brew install zls (or your OS package manager)',
    },
    {
      name = 'ty',
      cmd = { 'ty', 'server' },
      filetypes = { 'python' },
      root_markers = { 'ty.toml', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
      install_hint = 'Install: brew install ty',
    },
    {
      name = 'clangd',
      cmd = { 'clangd' },
      filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
      root_markers = {
        '.clangd',
        '.clang-tidy',
        '.clang-format',
        'compile_commands.json',
        'compile_flags.txt',
        'configure.ac',
        '.git',
      },
      install_hint = 'Install: brew install llvm (clangd is included)',
    },
    {
      name = 'gopls',
      cmd = { 'gopls' },
      filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
      root_markers = { 'go.work', 'go.mod', '.git' },
      install_hint = 'Install: brew install gopls (or: go install golang.org/x/tools/gopls@latest)',
    },
    {
      name = 'lua_ls',
      cmd = { 'lua-language-server' },
      filetypes = { 'lua' },
      root_markers = {
        '.emmyrc.json',
        '.luarc.json',
        '.luarc.jsonc',
        '.luacheckrc',
        '.stylua.toml',
        'stylua.toml',
        'selene.toml',
        'selene.yml',
        '.git',
      },
      settings = {
        Lua = {
          completion = { callSnippet = 'Replace' },
        },
      },
      install_hint = 'Install: brew install lua-language-server',
    },
    {
      name = 'asm_lsp',
      cmd = { 'asm-lsp' },
      filetypes = { 'asm', 'nasm', 'masm', 'gas', 's', 'vmasm' },
      root_markers = { '.asm-lsp.toml', '.git' },
      install_hint = 'Install: brew install asm-lsp',
    },
    {
      name = 'fish_lsp',
      cmd = { 'fish-lsp', 'start' },
      filetypes = { 'fish' },
      root_markers = { 'config.fish', '.git' },
      install_hint = 'Install: brew install fish-lsp',
    },
    {
      name = 'lemminx',
      cmd = { 'lemminx' },
      filetypes = { 'xml', 'xsd', 'xsl', 'xslt', 'svg' },
      root_markers = { '.git' },
      install_hint = 'Install: brew install lemminx (or: sdk install lemminx)',
    },
    {
      name = 'yamlls',
      cmd = { 'yaml-language-server', '--stdio' },
      filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab', 'yaml.helm-values' },
      root_markers = { '.git' },
      install_hint = 'Install: npm i -g yaml-language-server',
    },
    {
      name = 'jsonls',
      cmd = { 'vscode-json-language-server', '--stdio' },
      filetypes = { 'json', 'jsonc' },
      root_markers = { '.git' },
      install_hint = 'Install: npm i -g vscode-langservers-extracted',
    },
    {
      name = 'html',
      cmd = { 'vscode-html-language-server', '--stdio' },
      filetypes = { 'html' },
      root_markers = { '.git' },
      install_hint = 'Install: npm i -g vscode-langservers-extracted',
    },
    {
      name = 'taplo',
      cmd = { 'taplo', 'lsp', 'stdio' },
      filetypes = { 'toml' },
      root_markers = { 'taplo.toml', '.git' },
      install_hint = 'Install: brew install taplo (or: cargo install taplo-cli --locked)',
    },
    {
      name = 'tsserver',
      cmd = { 'typescript-language-server', '--stdio' },
      filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
      root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
      install_hint = 'Install: npm i -g typescript typescript-language-server',
    },
    {
      name = 'nixd',
      cmd = { 'nixd' },
      filetypes = { 'nix' },
      root_markers = { 'flake.nix', 'default.nix', 'shell.nix', '.git' },
      install_hint = 'Install: nix profile install nixpkgs#nixd (or: brew install nixd)',
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
              notify_missing(server, server.cmd[1])
            end)
          end
          return
        end

        local root_dir = server.root_dir
            and server.root_dir(bufnr)
            or default_root(bufnr, server.root_markers or { '.git' })

        vim.lsp.start({
          name = server.name,
          cmd = server.cmd,
          root_dir = root_dir,
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

  vim.api.nvim_create_user_command('LspCheck', function()
    local lines = { 'LSP binaries on PATH:' }
    local missing_bins = {}
    for _, server in ipairs(servers) do
      local bin = server.cmd[1]
      if vim.fn.executable(bin) == 1 then
        table.insert(lines, string.format('✓ %s (%s)', server.name, bin))
      else
        table.insert(lines, string.format('✗ %s (%s)', server.name, bin))
        table.insert(missing_bins, server)
      end
    end

    if #missing_bins > 0 then
      table.insert(lines, '')
      table.insert(lines, 'Missing:')
      for _, server in ipairs(missing_bins) do
        local hint = server.install_hint and (' - ' .. server.install_hint) or ''
        table.insert(lines, string.format('• %s (%s)%s', server.name, server.cmd[1], hint))
      end
    end

    vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO, { title = 'LspCheck', timeout = 5000 })
  end, {})
end

setup_lsp_keymaps()
setup_hardcoded_servers()
