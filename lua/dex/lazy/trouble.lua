return {
	{
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup({})

            -- TODO:
            --
			vim.keymap.set("n", "<leader>tt", function()
				require("trouble").toggle("diagnostics")
			end)

			vim.keymap.set("n", "[t", function()
				vim.cmd("Trouble diagnostics prev skip_groups=true jump=true")
			end)

			vim.keymap.set("n", "]t", function()
				vim.cmd("Trouble diagnostics next skip_groups=true jump=true")
			end)
		end,
	},
}
