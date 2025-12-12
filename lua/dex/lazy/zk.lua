return {
	{
		"zk-org/zk-nvim",

		-- FIX: Load the plugin immediately when opening a Markdown file
		-- This ensures the LSP starts so [[link]] completion works right away.
		ft = "markdown",

		config = function()
			require("zk").setup({
				picker = "fzf_lua",

				-- 2. LSP Setup
				lsp = {
					config = {
						cmd = { "zk", "lsp" },
						name = "zk",
                        filetypes = { "markdown" },
					},
					-- Automatically attach to Markdown files
					auto_attach = {
						enabled = true,
					},
				},
			})
		end,
		-- 3. Keybindings (The "Commander" mode)
		keys = {
			-- Open Notes (Search everything, similar to 'zk ls')
			{ "<leader>zls", "<cmd>ZkNotes<cr>", desc = "ZK Open Notes" },
			{ "<leader>zt", "<cmd>ZkTags<cr>", desc = "ZK Open Tags" },

			-- Search text (Grep)
			{
				"<leader>zg",
				"<cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search Content: ') } }<cr>",
				desc = "ZK Grep",
			},

			-- [zf] Search FLEET (Exclude 'vaults')
			{
				"<leader>zf",
				"<cmd>ZkNotes { excludeHrefs = { 'vaults' }, sort = { 'modified' } }<cr>",
				desc = "ZK Search Fleet",
			},

			-- [zv] Search VAULTS (Only 'vaults')
			{
				"<leader>zv",
				"<cmd>ZkNotes { hrefs = { 'vaults' }, sort = { 'modified' } }<cr>",
				desc = "ZK Search Vaults",
			},

			-- Backlinks (Who links to this file?)
			{ "<leader>zb", "<cmd>ZkBacklinks<cr>", desc = "ZK Backlinks" },

			-- Links (Who does this file link to?)
			{ "<leader>zl", "<cmd>ZkLinks<cr>", desc = "ZK Outbound Links" },
		},
	},
}
