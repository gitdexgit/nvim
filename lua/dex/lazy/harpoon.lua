return {
	{
		"ThePrimeagen/harpoon",
		dependencies = { "nvim-lua/plenary.nvim" },
		branch = "harpoon2", -- IMPORTANT: Install the new version

		config = function()

			local harpoon = require("harpoon")

			harpoon:setup({
				-- Make esc which exists harpoon save on toggle so you dont have to :w all the time to apply changes.
				settings = {
					save_on_toggle = true,
				},
			})

			-- Use empty setup table to prevent conflicts
			-- harpoon:setup({})

			vim.keymap.set("n", "<leader>A", function()
				harpoon:list():prepend()
			end, { desc = "Harpoon: Prepend (Set to Slot 1)" })

			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end, { desc = "Harpoon: Add File to List" })

			vim.keymap.set("n", "<C-e>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "Harpoon: Toggle Quick Menu" })

			--# an ergonomic way to bring the menu.
			vim.keymap.set("n", "<leader>h", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "Harpoon: Toggle Quick Menu" })

			-- Navigation Keymaps (Select Mark N)

            --# If you have more than 5 things inside harpoon... don't even bother remembering... just open harpoon and go to 5th location
            -- or don't have 5 things maniac.... You can only juggle 2 things or 3 things max... 4 if you stretch your luck. 5 is max sure the limit
			-- JUMPING (No Shift - Fastest Access)
			-- Using your layout: + [ { ( &
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

            -- Replace current file with a harpoon location and remove the old location from the list.
			-- REPLACING (Requires Shift - Rare Action)
			-- Using your layout: 1 2 3 4 5
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
		end,
	},
}
