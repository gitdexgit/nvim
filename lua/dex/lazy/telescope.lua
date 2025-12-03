return {
	"nvim-telescope/telescope.nvim",

	tag = "0.1.5",

	dependencies = {
		"nvim-lua/plenary.nvim",
	},

	config = function()
		local actions = require("telescope.actions")
		local action_layout = require("telescope.actions.layout") -- We'll need this for new mappings

		require("telescope").setup({})

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
		vim.keymap.set("n", "<C-p>", builtin.git_files, {})
		vim.keymap.set("n", "<leader>pws", function()
			local word = vim.fn.expand("<cword>")
			builtin.grep_string({ search = word })
		end)
		vim.keymap.set("n", "<leader>pWs", function()
			local word = vim.fn.expand("<cWORD>")
			builtin.grep_string({ search = word })
		end)
		vim.keymap.set("n", "<leader>ps", function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end)
		vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})

		vim.keymap.set("n", "<leader>g/", function()
			require("telescope.builtin").grep_string({ search = "" })
		end, { desc = "Telescope Grep all lines (press Enter)" })
		vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Telescope Fuzzy find in buffer" })
		vim.keymap.set("n", "<leader>r", builtin.registers, { desc = "Telescope Paste from register" })

		vim.keymap.set("n", "<leader>j", builtin.jumplist, { desc = "Telescope Jumplist" })
		vim.keymap.set("n", "<leader>m", builtin.marks, { desc = "Telescope Find marks" })

		vim.keymap.set("n", "<A-p>", builtin.resume, { desc = "Telescope Resume" })
		vim.keymap.set("n", "<leader>;", builtin.resume, { desc = "Telescope Resume" })

        vim.keymap.set("n", "<leader>?", builtin.builtin, { desc = "Telescope Command Palette (All Commands)" })
	end,
}
