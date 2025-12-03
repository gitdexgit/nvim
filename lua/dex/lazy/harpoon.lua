return {
    {
        "ThePrimeagen/harpoon",
        dependencies = { "nvim-lua/plenary.nvim" },
        branch = "harpoon2", -- IMPORTANT: Install the new version

        config = function()
            local harpoon = require("harpoon")

            -- Use empty setup table to prevent conflicts
            harpoon:setup({})

            vim.keymap.set("n", "<leader>A", function()
                harpoon:list():prepend()
            end, { desc = "Harpoon: Prepend (Set to Slot 1)" })

            vim.keymap.set("n", "<leader>a", function()
                harpoon:list():add()
            end, { desc = "Harpoon: Add File to List" })

            vim.keymap.set("n", "<C-e>", function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end, { desc = "Harpoon: Toggle Quick Menu" })

            -- Navigation Keymaps (Select Mark N)
            vim.keymap.set("n", "<C-h>", function()
                harpoon:list():select(1)
            end, { desc = "Harpoon: Go to Mark 1" })

            vim.keymap.set("n", "<C-t>", function()
                harpoon:list():select(2)
            end, { desc = "Harpoon: Go to Mark 2" })

            vim.keymap.set("n", "<C-n>", function()
                harpoon:list():select(3)
            end, { desc = "Harpoon: Go to Mark 3" })

            vim.keymap.set("n", "<C-s>", function()
                harpoon:list():select(4)
            end, { desc = "Harpoon: Go to Mark 4" })

            -- Replace Keymaps (Replace Mark N with Current File)
            vim.keymap.set("n", "<leader><C-h>", function()
                harpoon:list():replace_at(1)
            end, { desc = "Harpoon: Replace Mark 1" })

            vim.keymap.set("n", "<leader><C-t>", function()
                harpoon:list():replace_at(2)
            end, { desc = "Harpoon: Replace Mark 2" })

            vim.keymap.set("n", "<leader><C-n>", function()
                harpoon:list():replace_at(3)
            end, { desc = "Harpoon: Replace Mark 3" })

            vim.keymap.set("n", "<leader><C-s>", function()
                harpoon:list():replace_at(4)
            end, { desc = "Harpoon: Replace Mark 4" })
        end,
    },
}
