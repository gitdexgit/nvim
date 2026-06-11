return {
	"mg979/vim-visual-multi",
	branch = "master",
	-- This plugin must be loaded at startup to prevent the E121/E605 errors
	lazy = false,
	init = function()
		-- 1. Disable default mappings
		vim.g.VM_default_mappings = 0

		-- 2. Define all mappings in the VM_maps table
		-- Mapping both 'Find Under' and 'Find Subword Under' to the same key
		-- is a specific fix for the "Undefined variable: s:F" error.

		vim.g.VM_maps = {
			["Find Under"] = "<leader>nn",
			["Find Subword Under"] = "<leader>nN",
			["Find Prev"] = "<leader>N",
			["Select All"] = "<leader>na",
			["Add Cursor Down"] = "<leader>>",
			["Add Cursor Up"] = "<leader><",
			["Add Cursor At Pos"] = "<leader>np",
			["Skip Region"] = "<leader><Bar>", -- escape the pipe
			-- ["Remove Region"] = "<C-x>r",
			["Remove Region"] = "<leader>nr",
		}
	end,
}
