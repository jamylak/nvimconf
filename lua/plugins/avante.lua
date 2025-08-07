return {
  "yetone/avante.nvim",
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  -- ⚠️ must add this setting! ! !
  build = vim.fn.has("win32") ~= 0
      and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
  -- TODO: Remove this
  -- event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  ---@module 'avante'
  ---@type avante.Config
  keys = { "<leader>aa" },
  opts = {
    -- add any opts here
    -- for example
    provider = "vertex",
    providers = {
      vertex = {
        endpoint = "https://aiplatform.googleapis.com/v1/projects/PROJECT_ID/locations/LOCATION/publishers/google/models",
        model = "gemini-2.5-flash",
        timeout = 30000, -- Timeout in milliseconds
        -- context_window = 1048576,
        -- use_ReAct_prompt = true,
        -- extra_request_body = {
        --   generationConfig = {
        --     temperature = 0.75,
        --   },
        -- },
      }
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    -- "stevearc/dressing.nvim",        -- for input provider dressing
    -- "folke/snacks.nvim",             -- for input provider snacks
  },
}
