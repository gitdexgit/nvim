return {
    "stevearc/conform.nvim",
    opts = {},
    config = function()
        require("conform").setup({
            format_on_save = {
                timeout_ms = 5000,
                lsp_format = "fallback",
            },
            formatters_by_ft = {
                c = { "clang-format" },
                cpp = { "clang-format" },
                python = { "black" },
                lua = { "stylua" },
                go = { "gofmt" }, -- Note: Go forces tabs by design
                javascript = { "prettier" },
                typescript = { "prettier" },
                elixir = { "mix" },
            },
            formatters = {
                ["clang-format"] = {
                    prepend_args = { "--style={IndentWidth: 4, UseTab: Never}" },
                },
                ["stylua"] = {
                    prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
                },
                ["prettier"] = {
                    prepend_args = { "--tab-width", "4", "--use-tabs", "false" },
                },
            },
        })

        vim.keymap.set("n", "<leader>f", function()
            require("conform").format({ bufnr = 0 })
        end)
    end,
}
