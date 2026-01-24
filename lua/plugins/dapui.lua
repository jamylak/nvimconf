-- TODO: 2nd layout i can in 1 click switch between?
-- could have eg. 3 different useful layouts eg. 1 with vertical
-- right REPL
-- TODO:
-- 1. Assembly link EACH op code -> Description / Docs
-- 2. Attach to dap disasm view and shift K = doc lookup above

local repl_only_mode = false

local layouts = {
	repl_only = { {
		elements = { { id = "repl", size = 1 } },
		position = "right",
		size = 80,
	} },
	python = { {
		elements = { {
			id = "scopes",
			size = 0.25
		}, {
			id = "breakpoints",
			size = 0.25
		}, {
			id = "stacks",
			size = 0.25
		}, {
			id = "watches",
			size = 0.25
		} },
		position = "left",
		size = 40
	}, {
		elements = {
			{
				id = "repl",
				size = 1.0
			},
		},
		position = "bottom",
		size = 10
	} },
	cpp = { {
		elements = { {
			id = "scopes",
			size = 0.25
		}, {
			id = "breakpoints",
			size = 0.25
		}, {
			id = "stacks",
			size = 0.25
		}, {
			id = "watches",
			size = 0.25
		} },
		position = "left",
		size = 40
	}, {
		elements = {
			{
				id = "repl",
				size = 0.5
			},
			{
				id = "disassembly",
				size = 0.5,
			},
		},
		position = "bottom",
		size = 10
	} },
}

local function apply_layout(name)
	require('dapui').setup({
		layouts = layouts[name],
	})
end

local function apply_layout_for(filetype)
	if repl_only_mode then
		apply_layout("repl_only")
		return
	end
	if filetype == 'python' then
		apply_layout("python")
		return
	end
	if filetype == 'cpp' or filetype == 'c' or filetype == 'zig' or filetype == 'rust' then
		apply_layout("cpp")
		return
	end
	apply_layout("python")
end

local function run_dap_with_restart(opts)
	local dap = require('dap')
	local dapui = require('dapui')

	if dap.session() then
		local function on_terminated()
			dap.listeners.after.event_terminated[opts.listener_key] = nil
			if opts.after_terminate_message then
				vim.notify(opts.after_terminate_message, vim.log.levels.DEBUG)
			end
			opts.run()
			pcall(dapui.open)
		end

		dap.listeners.after.event_terminated[opts.listener_key] = on_terminated
		if opts.before_terminate_message then
			vim.notify(opts.before_terminate_message, vim.log.levels.WARN)
		end
		dap.terminate()
	else
		if opts.start_message then
			vim.notify(opts.start_message, vim.log.levels.DEBUG)
		end
		opts.run()
		pcall(dapui.open)
	end
end

local function ensure_dap_config()
	local config_dir = vim.fn.getcwd() .. "/.nvim"
	local config_file = config_dir .. "/dap.lua"

	-- Create directory if missing
	if not vim.loop.fs_stat(config_dir) then
		vim.fn.mkdir(config_dir, "p")
	end

	-- Write template if file missing
	if not vim.loop.fs_stat(config_file) then
		local template = [[
return {
  python = {
--     args = { "--domains", "example.com", "--debug" },
--     justMyCode = true,
--     stopOnExit = false,
--     request = 'attach',
--     connect = {
--       host = 'localhost',
--       port = 5678,
--     }
--     pythonPath = function()
--       return ".venv/bin/python3"
--     end,
  },
  cpp = {
--     stopOnEntry = false,
--     args = { "--log-level", "trace" },
--     request = 'attach',
--     program = "build/main",
--     initCommands = { "breakpoint set --name main" },
--     initCommands = {  },
  },
  zig = {
--     stopOnEntry = false,
--     request = 'attach',
--     program = "zig-out/bin/main",
--     args = {},
--     initCommands = { "breakpoint set --name main" },
  },
--   rust = {
--     request = 'launch',
--     program = "target/debug/my-bin",
--     stopOnEntry = false,
--     args = { "--port", "8080" },
--     initCommands = { "breakpoint set --name main" },
--     -- request = 'attach',
--     -- connect = { host = 'localhost', port = 1234 },
--   }
}
]]
		local fd = assert(io.open(config_file, "w"))
		fd:write(template)
		fd:close()
		vim.notify("Created DAP config template at " .. config_file, vim.log.levels.DEBUG)
	end
end

local function load_dap_project_config(lang)
	ensure_dap_config()
	local config_path = vim.fn.getcwd() .. "/.nvim/dap.lua"
	local ok, config = pcall(dofile, config_path)
	if not ok or type(config) ~= "table" then
		return {}
	end
	return config[lang] or {}
end

local function launch_python_debugger()
	local dap = require('dap')
	local breakpoints = require('dap.breakpoints')
	local cwd = vim.fn.getcwd() -- Define cwd here
	local user_cfg = load_dap_project_config("python")

	if user_cfg.stopOnExit ~= false then
		local cur_bufnr = vim.api.nvim_get_current_buf()
		local last_line = vim.fn.line('$')
		breakpoints.set({}, cur_bufnr, last_line)
	end

	local function dap_run_python()
		-- Merge defaults into cfg
		local defaults = {
			type = 'python',
			request = 'launch',
			name = 'Autopilot',
			module = nil,
			program = vim.fn.expand('%'),
			args = {},
			justMyCode = false,
			cwd = cwd,
			connect = nil,
			stopOnEntry = false,
			pythonPath = function()
				return vim.fn.filereadable('.venv/bin/python3') == 1 and '.venv/bin/python3' or 'python3'
			end,
			initCommands = {},
		}
		local config = vim.tbl_deep_extend('force', defaults, user_cfg or {})
		-- If module is set, ignore program
		if config.module then
			config.program = nil
		end
		dap.run(config)
	end

	apply_layout_for("python")
	run_dap_with_restart({
		listener_key = "restart_and_run_python",
		before_terminate_message = "⏳ Terminating previous DAP session...",
		after_terminate_message = "✅ Old DAP session terminated, launching new debugger",
		start_message = "✅ Launching debugger",
		run = dap_run_python,
	})
end

local pick_process = function(callback)
	local pickers = require('telescope.pickers')
	local finders = require('telescope.finders')
	local conf = require('telescope.config').values
	local action_state = require('telescope.actions.state')
	local actions = require('telescope.actions')

	vim.fn.jobstart({ 'ps', '-A', '-o', 'pid=,command=' }, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			table.remove(data, #data) -- remove last empty line
			pickers.new({}, {
				prompt_title = 'Select process',
				finder = finders.new_table { results = data },
				sorter = conf.generic_sorter({}),
				attach_mappings = function(prompt_bufnr, map)
					actions.select_default:replace(function()
						local selection = action_state.get_selected_entry()[1]
						local pid = tonumber(selection:match('^%s*(%d+)'))
						actions.close(prompt_bufnr)
						callback(pid)
					end)
					return true
				end
			}):find()
		end
	})
end


local function launch_c_cpp_debugger()
	local dap = require('dap')
	local cppplug = require('cppplug')
	local cwd = vim.fn.getcwd()

	local function on_build_success()
		vim.notify("✅ Build succeeded, launching debugger", vim.log.levels.DEBUG)

		local user_cfg = load_dap_project_config("cpp")

		-- Define default config
		local defaults = {
			name = "Launch compiled .out",
			type = 'lldb',
			request = 'launch',
			program = cppplug.get_default_executable_name(),
			cwd = cwd,
			pid = nil,
			stopOnEntry = false,
			args = {},
			initCommands = { "breakpoint set --name main" }
		}

		-- Merge cfg into defaults
		local config = vim.tbl_deep_extend("force", defaults, user_cfg or {})
		if config.request == 'attach' then
			config.program = nil
			if not config.connect then
				config.pid = function()
					return coroutine.create(function(co)
						pick_process(function(pid)
							coroutine.resume(co, pid)
						end)
					end)
				end
			end
		end

		apply_layout_for("cpp")
		run_dap_with_restart({
			listener_key = "restart_and_run_cpp",
			before_terminate_message = "⏳ Terminating previous DAP session...",
			after_terminate_message = "✅ Old DAP session terminated, launching new debugger",
			start_message = "✅ Launching debugger",
			run = function()
				dap.run(config)
			end,
		})
	end

	local function on_build_failure(_)
		-- vim.notify("❌ Build failed\n", vim.log.levels.ERROR)
	end

	-- Check if CMakeLists.txt exists
	if vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
		-- Assume already configured, just build once
		cppplug.build_cmake_once(on_build_success, on_build_failure)
	else
		-- This will setup a new project in debug config
		cppplug.setup_new_project(on_build_success, on_build_failure)
	end
end

local function launch_rust_debugger()
	local dap = require('dap')
	local cwd = vim.fn.getcwd()

	local function on_build_success()
		vim.notify("✅ Build succeeded, launching debugger", vim.log.levels.DEBUG)

		local user_cfg = load_dap_project_config("rust")

		-- Define default config
		local defaults = {
			name = "Launch compiled .out",
			type = 'lldb',
			-- type = 'codelldb',
			request = 'launch',
			-- TODO: get from rustaceanvim??
			program = "target/debug/" .. vim.fn.fnamemodify(cwd, ":t"),
			cwd = cwd,
			pid = nil,
			stopOnEntry = false,
			args = {},
			initCommands = { "breakpoint set --name main" }
		}

		-- Merge cfg into defaults
		local config = vim.tbl_deep_extend("force", defaults, user_cfg or {})
		if config.request == 'attach' then
			config.program = nil
			if not config.connect then
				config.pid = function()
					return coroutine.create(function(co)
						pick_process(function(pid)
							coroutine.resume(co, pid)
						end)
					end)
				end
			end
		end

		apply_layout_for("rust")
		run_dap_with_restart({
			listener_key = "restart_and_run_rust",
			before_terminate_message = "⏳ Terminating previous DAP session...",
			after_terminate_message = "✅ Old DAP session terminated, launching new debugger",
			start_message = "✅ Launching debugger",
			run = function()
				dap.run(config)
			end,
		})
	end

	local function on_build_failure(_)
		-- vim.notify("❌ Build failed\n", vim.log.levels.ERROR)
	end

	-- TODO: Call rustaceanvim debug build?
	-- Or own?
	on_build_success()
end

local function launch_zig_debugger()
	local dap = require('dap')
	local cwd = vim.fn.getcwd()
	local user_cfg = load_dap_project_config("zig")

	local defaults = {
		name = "Launch Zig binary",
		type = 'lldb',
		request = 'launch',
		program = cwd .. "/zig-out/bin/" .. vim.fn.fnamemodify(cwd, ":t"),
		cwd = cwd,
		stopOnEntry = false,
		args = {},
		initCommands = { "breakpoint set --name main" }
	}

	local config = vim.tbl_deep_extend("force", defaults, user_cfg or {})

	if config.request == 'attach' then
		config.program = nil
		config.pid = function()
			return coroutine.create(function(co)
				pick_process(function(pid)
					coroutine.resume(co, pid)
				end)
			end)
		end
	end

	apply_layout_for("zig")
	run_dap_with_restart({
		listener_key = "restart_and_run_zig",
		before_terminate_message = "⏳ Terminating previous DAP session...",
		after_terminate_message = "✅ Old DAP session terminated, launching new Zig debugger",
		start_message = "✅ Launching Zig debugger",
		run = function()
			dap.run(config)
		end,
	})
end

local function dispatch_dap_launch()
	local filetype = vim.bo.filetype
	if filetype == 'python' then
		launch_python_debugger()
	elseif filetype == 'cpp' or filetype == 'c' then
		launch_c_cpp_debugger()
	elseif filetype == 'zig' then
		launch_zig_debugger()
	elseif filetype == 'rust' then
		launch_rust_debugger()
	else
		vim.notify("No debugger configured for filetype: " .. filetype, vim.log.levels.WARN)
	end
end


return {
	'rcarriga/nvim-dap-ui',
	dependencies = {
		'mfussenegger/nvim-dap',
		'nvim-neotest/nvim-nio',
		'Jorenar/nvim-dap-disasm',
		"rcarriga/cmp-dap",
	},
	config = function()
		-- Dap repl <c-w> behaviour fix, doesn't delete word
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "dap-repl",
			callback = function(args)
				vim.keymap.set("i", "<c-w>", function()
					-- Weirdly <c-w> doesnt work like normal
					-- <c-o>db also doesnt work
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>bC", true, false, true), "t", true)
				end, { buffer = args.buf, noremap = true, silent = true, desc = "Up" })
			end,
		})

		vim.api.nvim_create_user_command("EnsureDapConfigTemplate", ensure_dap_config, {
			desc = "Create a template for DAP configuration in the current project if it doesn't exist",
		})
		local dap, dapui = require 'dap', require 'dapui'

		-- needs a default layout as a hack fix for rustaceanvim
		apply_layout("cpp")

		require('nvim-dap-virtual-text').setup({
			commented = true
		})

		require("dap-disasm").setup({})
		vim.api.nvim_create_user_command("DapToggleREPLOnly", function()
			local filetype = vim.bo.filetype

			repl_only_mode = not repl_only_mode

			if dap.session() then
				dapui.close()
			end

			apply_layout_for(filetype)

			if dap.session() then
				dapui.open()
			end
		end, {
			desc = "Toggle DAP REPL only mode",
		})

		dap.listeners.after.event_initialized['dapui_config'] = function()
			dapui.open()
		end
	end,
	cmd = {
		"EnsureDapConfigTemplate",
	},
	keys = {
		{
			'<leader>gg', -- or any key you want
			function()
				require('dapui').toggle()
			end,
			desc = 'Toggle DAP UI',
		},
		{
			'<leader>gb',
			function()
				require('dap').toggle_breakpoint()
			end,
			desc = 'Toggle Breakpoint',
		},
		{
			'<leader><leader>b',
			function()
				require('dap').toggle_breakpoint()
			end,
			desc = 'Toggle Breakpoint',
		},
		{
			'<leader>gc',
			function()
				require('dap').continue()
			end,
			desc = 'Continue Debugging',
		},
		{
			'<leader><leader>c',
			function()
				require('dap').continue()
			end,
			desc = 'Continue Debugging',
		},
		-- Idea: A version of this which just runs through nokrmally
		-- no isntant break? -- maybe
		--
		-- TODO: Need another keymap when there is eg.
		-- project wide cmake
		-- or eg. just a very custom build command
		-- test different debugs on large projects etc until there is
		-- a reliable way
		{
			'<leader>gj',
			function()
				dispatch_dap_launch()
			end,
			desc = 'Launch Debugger (Python/C++)',
		},
		{
			'<leader>c',
			function()
				dispatch_dap_launch()
			end,
			desc = 'Launch Debugger (Python/C++)',
		},
		{
			'<leader>gn',
			function()
				require('dap').step_over()
			end,
			desc = 'Step Over',
		},
		{
			'<leader><leader>n',
			function()
				require('dap').step_over()
			end,
			desc = 'Step Over',
		},
		{
			'<leader>gi',
			function()
				require('dap').step_into()
			end,
			desc = 'Step Into',
		},

		{
			'<leader><leader>i',
			function()
				require('dap').step_into()
			end,
			desc = 'Step Into',
		},
		{
			'<leader>go',
			function()
				require('dap').step_out()
			end,
			desc = 'Step Out',
		},
		{
			'<leader><leader>o',
			function()
				require('dap').step_out()
			end,
			desc = 'Step Out',
		},
		{
			'<leader>gr',
			function()
				require('dap').run_to_cursor()
			end,
			desc = 'Run to Cursor',
		},
		{
			'<leader><leader>r',
			function()
				require('dap').run_to_cursor()
			end,
			desc = 'Run to Cursor',
		},
		{
			'<leader>gq',
			function()
				require('dap').restart()
			end,
			desc = 'Restart Debugging',
		},
		{
			'<leader>gx',
			function()
				require('dap').terminate()
			end,
			desc = 'Terminate Debugging',
		},
		{
			'<leader><leader>x',
			function()
				require('dap').terminate()
			end,
			desc = 'Terminate Debugging',
		},
		{
			'<leader>ge',
			function()
				require('dap.ui.widgets').hover()
			end,
			desc = 'Evaluate Expression',
		},
	},
}
