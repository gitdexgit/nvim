return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",

        -- ADAPTERS FOR YOUR LANGUAGES (Python, Lua, Bash)
        "nvim-neotest/neotest-python",
        "nvim-neotest/neotest-plenary",
        "rcasia/neotest-bash",
    },
    config = function()
        require("neotest").setup({
            adapters = {
                -- Activate the adapters for your languages
                require("neotest-python"),
                require("neotest-plenary"),
                require("neotest-bash"),
            },
            -- You can optionally add a general adapter for any unsupported runner
            -- using vim-test, but the dedicated adapters are better.
        })

        -- Keymaps (tr, tv, ts, td, to, ta) are universal and remain excellent.

        vim.keymap.set("n", "<leader>tr", function()
            require("neotest").run.run({
                suite = false,
                -- Removed unnecessary 'testify = true' since it's Go-specific,
                -- or just an obsolete flag. Cleaner to remove it.
            })
        end, { desc = "Test: Running Nearest Test" })

        vim.keymap.set("n", "<leader>tv", function()
            require("neotest").summary.toggle()
        end, { desc = "Test: Summary Toggle" })

        vim.keymap.set("n", "<leader>ts", function()
            require("neotest").run.run({
                suite = true,
            })
        end, { desc = "Test: Running Test Suite" })

        vim.keymap.set("n", "<leader>td", function()
            require("neotest").run.run({
                suite = false,
                strategy = "dap", -- Uses your DAP setup to debug the test
            })
        end, { desc = "Test: Debug Nearest Test" })

        vim.keymap.set("n", "<leader>to", function()
            require("neotest").output.open()
        end, { desc = "Test: Open test output" })

        vim.keymap.set("n", "<leader>ta", function()
            require("neotest").run.run(vim.fn.getcwd())
        end, { desc = "Test: Run all tests in directory" })

    end
}

