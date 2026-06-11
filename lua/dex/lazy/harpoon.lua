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

			local function ui_swap(target_idx)
				if vim.bo.filetype ~= "harpoon" then
					return
				end

				-- m' : set mark at current line
				-- Vy : visual-line yank current line
				-- %dG: go to target line (1, 2, etc)
				-- Vp : visual-line paste (replaces target, puts target in register)
				-- '' : jump back to mark
				-- Vp : visual-line paste (replaces original with target)
				local keys = string.format("normal! m'Vy%dGVp''Vp", target_idx)
				vim.cmd(keys)

				-- Move cursor to the new position of your file
				vim.cmd("normal! " .. target_idx .. "G")
			end

			vim.keymap.set("n", "<leader>A", function()
				harpoon:list():prepend()
			end, { desc = "Harpoon: Prepend (Set to Slot 1)" })

			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end, { desc = "Harpoon: Add File to List" })

            -- OLD Was stupid:
			-- I just never use it I prefer <leader>h
			-- vim.keymap.set("n", "<C-e>", function()
			-- 	harpoon.ui:toggle_quick_menu(harpoon:list(), { height_in_lines = 10 })
			-- end, { desc = "Harpoon: Toggle Quick Menu" })

            -- Make it C-e man I can hit C-e so fast with capslock
			-- vim.keymap.set("n", "<leader>h", function()
			-- 	harpoon.ui:toggle_quick_menu(harpoon:list(), { height_in_lines = 10 })
			-- end, { desc = "Harpoon: Toggle Quick Menu" })

			vim.keymap.set("n", "<C-e>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list(), { height_in_lines = 10 })
			end, { desc = "Harpoon: Toggle Quick Menu" })

			vim.keymap.set("n", "<leader>e", function()
				harpoon.ui:toggle_quick_menu(harpoon:list(), { height_in_lines = 10 })
			end, { desc = "Harpoon: Toggle Quick Menu" })

			-- [Select Keymaps]
			vim.keymap.set("n", "<leader>1", function()
				harpoon:list():select(1)
			end)
			vim.keymap.set("n", "<leader>2", function()
				harpoon:list():select(2)
			end)
			vim.keymap.set("n", "<leader>3", function()
				harpoon:list():select(3)
			end)
			vim.keymap.set("n", "<leader>4", function()
				harpoon:list():select(4)
			end)
			vim.keymap.set("n", "<leader>5", function()
				harpoon:list():select(5)
			end)
			vim.keymap.set("n", "<leader>6", function()
				harpoon:list():select(6)
			end)
			vim.keymap.set("n", "<leader>7", function()
				harpoon:list():select(7)
			end)
			vim.keymap.set("n", "<leader>8", function()
				harpoon:list():select(8)
			end)
			vim.keymap.set("n", "<leader>9", function()
				harpoon:list():select(9)
			end)

            -- I can't have more than 10 because there is a wait then I type <leader>1
			-- vim.keymap.set("n", "<leader>10", function()
			-- 	harpoon:list():select(10)
			-- end)

			-- [Replace Keymaps]
			vim.keymap.set("n", "<leader>!", function()
				harpoon:list():replace_at(1)
			end)
			vim.keymap.set("n", "<leader>@", function()
				harpoon:list():replace_at(2)
			end)
			vim.keymap.set("n", "<leader>#", function()
				harpoon:list():replace_at(3)
			end)
			vim.keymap.set("n", "<leader>$", function()
				harpoon:list():replace_at(4)
			end)
			vim.keymap.set("n", "<leader>%", function()
				harpoon:list():replace_at(5)
			end)
			vim.keymap.set("n", "<leader>^", function()
				harpoon:list():replace_at(6)
			end)
			vim.keymap.set("n", "<leader>&", function()
				harpoon:list():replace_at(7)
			end)
			vim.keymap.set("n", "<leader>*", function()
				harpoon:list():replace_at(8)
			end)
			vim.keymap.set("n", "<leader>(", function()
				harpoon:list():replace_at(9)
			end)

            -- if there are no <leader>10 then what is the point of <leader>*
			-- vim.keymap.set("n", "<leader>*", function()
			-- 	harpoon:list():replace_at(10)
			-- end)

			-- NEW: Leader + Physical F-keys (F1, F2, etc.)
			for i = 1, 10 do
				vim.keymap.set("n", "<leader><F" .. i .. ">", function()
					ui_swap(i)
				end, { desc = "Harpoon UI: Swap with Slot " .. i })
			end
		end,
	},
}
