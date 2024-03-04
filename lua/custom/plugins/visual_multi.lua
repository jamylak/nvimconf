-- Not playing well with lua snips eg. CTRL-Y not working
vim.g.VM_leader = "=" -- sets vim.g.VM_leader for visual multi
return {
	"mg979/vim-visual-multi",
	branch = "master",
	config = function()
		vim.keymap.set("n", "<A-j>", "<Plug>(VM-Select-Cursor-Down)")
		vim.keymap.set("n", "<A-k>", "<Plug>(VM-Select-Cursor-Up)")
	end,
}
