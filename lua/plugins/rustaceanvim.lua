-- Custom adapter
-- vim.g.rustaceanvim = function()
--   -- Update this path
--   -- local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/'
--   -- local codelldb_path = extension_path .. 'adapter/codelldb'
--   -- local liblldb_path = extension_path .. 'lldb/lib/liblldb'
--   local codelldb_path = "/Users/james/apps/codelldb-darwin-arm64/extension/adapter/codelldb"
--   local liblldb_path = "/Users/james/apps/codelldb-darwin-arm64/extension/lldb/lib/liblldb"
--   local this_os = vim.uv.os_uname().sysname
--   -- The liblldb extension is .so for Linux and .dylib for MacOS
--
--   liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
--
--   local cfg = require('rustaceanvim.config')
--   return {
--     dap = {
--       adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
--     },
--   }
-- end

return {
  'mrcjkb/rustaceanvim',
  version = '^6', -- Recommended
  lazy = false,   -- This plugin is already lazy
  init = function()
    vim.g.rustaceanvim = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, blink = pcall(require, 'blink.cmp')
      if ok and type(blink.get_lsp_capabilities) == 'function' then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end
      local this_os = vim.uv.os_uname().sysname
      local dap = nil
      if this_os == "Darwin" then
        local codelldb_path = "/Users/james/apps/codelldb-darwin-arm64/extension/adapter/codelldb"
        local liblldb_path = "/opt/homebrew/opt/llvm/lib/liblldb.dylib"
        local cfg = require('rustaceanvim.config')
        dap = {
          adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
        }
      end

      return {
        dap = dap,
        server = {
          capabilities = capabilities,
        },
      }
    end
  end,
}
