return {
	{
		"ibhagwan/fzf-lua",
		-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional for icons
		config = function()
			-- 1. Setup Fzf-lua
			require("fzf-lua").setup({
				winopts = {
					fullscreen = true,
					preview = {
						layout = "vertical",
						vertical = "up:70%",
					},
				},

				-- use exact string matching, but only for the files picker
				files = {
					fzf_opts = {
						["--exact"] = "",
						["--no-sort"] = "",
					},
				},

				keymap = {
					builtin = {
						-- Use your Alt-j / Alt-k scrolling logic
						["<M-j>"] = "preview-page-down",
						["<M-k>"] = "preview-page-up",
						["<M-S-j>"] = "preview-down",
						["<M-S-k>"] = "preview-up",
					},
					fzf = {
						["ctrl-q"] = "select-all+accept",
					},
				},
			})

			-- 2. Define global keymaps (this is where they should be moved)
			vim.keymap.set(
				"n",
				"<leader>pf",
				require("fzf-lua").files,
				{ noremap = true, silent = true, desc = "FZF-Lua: Find Files" }
			)
			vim.keymap.set(
				"n",
				"<leader>pq",
				require("fzf-lua").quickfix,
				{ noremap = true, silent = true, desc = "FZF-Lua: Find Files" }
			)
			vim.keymap.set(
				"n",
				"<leader>/",
				require("fzf-lua").grep_curbuf,
				{ noremap = true, silent = true, desc = "FZF-Lua: Find Files" }
			)
			vim.keymap.set(
				"n",
				"<leader>g",
				require("fzf-lua").live_grep,
				{ noremap = true, silent = true, desc = "FZF-Lua: Live Grep" }
			)
			vim.keymap.set(
				"n",
				"<leader>pb",
				require("fzf-lua").buffers,
				{ noremap = true, silent = true, desc = "FZF-Lua: Buffers" }
			)
			vim.keymap.set(
				"n",
				"<leader>?",
				require("fzf-lua").builtin,
				{ noremap = true, silent = true, desc = "FZF-Lua: Builtin/Help" }
			)
		end,
	},
}
