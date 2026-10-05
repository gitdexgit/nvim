return {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
        { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
    },

    vim.keymap.set("n", "<leader>pv", function()
        require("oil").open()
    end),
}
