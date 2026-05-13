return {
	{
		"ThePrimeagen/harpoon",
		dependencies = { "nvim-lua/plenary.nvim" },
		branch = "harpoon2",

		config = function()
			local harpoon = require("harpoon")

			harpoon:setup({
				settings = {
					save_on_toggle = true,
				},
			})

			vim.keymap.set("n", "<leader>A", function()
				harpoon:list():prepend()
			end, { desc = "Harpoon: Prepend (Set to Slot 1)" })

            -- append to the lest
			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end, { desc = "Harpoon: Add File to List" })

			vim.keymap.set("n", "<C-e>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list(), { height_in_lines = 10 })
			end, { desc = "Harpoon: Toggle Quick Menu" })

			vim.keymap.set("n", "<leader>h", function()
				harpoon.ui:toggle_quick_menu(harpoon:list(), { height_in_lines = 10 })
			end, { desc = "Harpoon: Toggle Quick Menu" })


            -- programming symbols do the switch.
			vim.keymap.set("n", "<leader>+", function()
				harpoon:list():select(1)
			end, { desc = "Harpoon: Go to 1" })
			vim.keymap.set("n", "<leader>[", function()
				harpoon:list():select(2)
			end, { desc = "Harpoon: Go to 2" })
			vim.keymap.set("n", "<leader>{", function()
				harpoon:list():select(3)
			end, { desc = "Harpoon: Go to 3" })
			vim.keymap.set("n", "<leader>(", function()
				harpoon:list():select(4)
			end, { desc = "Harpoon: Go to 4" })
			vim.keymap.set("n", "<leader>&", function()
				harpoon:list():select(5)
			end, { desc = "Harpoon: Go to 5" })
			vim.keymap.set("n", "<leader>=", function()
				harpoon:list():select(6)
			end, { desc = "Harpoon: Go tho 6" })
			vim.keymap.set("n", "<leader>)", function()
				harpoon:list():select(7)
			end, { desc = "Harpoon: Go tho 7" })
			vim.keymap.set("n", "<leader>}", function()
				harpoon:list():select(8)
			end, { desc = "Harpoon: Go tho 8" })
			vim.keymap.set("n", "<leader>]", function()
				harpoon:list():select(9)
			end, { desc = "Harpoon: Go tho 9" })
			vim.keymap.set("n", "<leader>*", function()
				harpoon:list():select(10)
			end, { desc = "Harpoon: Go tho 10" })



            -- leader+shift+programming symbols do the swap
			vim.keymap.set("n", "<leader>1", function()
				harpoon:list():replace_at(1)
			end, { desc = "Harpoon: Replace Slot 1" })
			vim.keymap.set("n", "<leader>2", function()
				harpoon:list():replace_at(2)
			end, { desc = "Harpoon: Replace Slot 2" })
			vim.keymap.set("n", "<leader>3", function()
				harpoon:list():replace_at(3)
			end, { desc = "Harpoon: Replace Slot 3" })
			vim.keymap.set("n", "<leader>4", function()
				harpoon:list():replace_at(4)
			end, { desc = "Harpoon: Replace Slot 4" })
			vim.keymap.set("n", "<leader>5", function()
				harpoon:list():replace_at(5)
			end, { desc = "Harpoon: Replace Slot 5" })
			vim.keymap.set("n", "<leader>6", function()
				harpoon:list():replace_at(6)
			end, { desc = "Harpoon: Replace Slot 6" })
			vim.keymap.set("n", "<leader>7", function()
				harpoon:list():replace_at(7)
			end, { desc = "Harpoon: Replace Slot 7" })
			vim.keymap.set("n", "<leader>8", function()
				harpoon:list():replace_at(8)
			end, { desc = "Harpoon: Replace Slot 8" })
			vim.keymap.set("n", "<leader>9", function()
				harpoon:list():replace_at(9)
			end, { desc = "Harpoon: Replace Slot 9" })
			vim.keymap.set("n", "<leader>10", function()
				harpoon:list():replace_at(10)
			end, { desc = "Harpoon: Replace Slot 10" })
		end,
	},
}
