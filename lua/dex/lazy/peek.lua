return {
	{
		"toppair/peek.nvim",
		event = { "VeryLazy" },
		build = "deno task --quiet build:fast",
		config = function()
			require("peek").setup({
				filetype = { "markdown", "conf" },



                -- 2. AUTO-LOADING (Crucial for fast note-taking)
                -- -- if you want to make it like OBSIDIAN live preview <--- add these 2
                -- auto_load = true,         -- Opens the preview window automatically when you enter a markdown buffer.
                -- close_on_bdelete = true,  -- Automatically closes the preview window when you close the markdown buffer.

				-- 3. PERFORMANCE: Good for large notes
				update_on_change = true,
				throttle_at = 200000, -- Stop live updating if the file is larger than 200KB (optional, but safer).
                syntax = true,
			})
			vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
			vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
		end,
	},
}

