return {
	"gbprod/yanky.nvim",
	opts = {
		highlight = {
			on_yank = false,
			on_put = false,
			-- timer = 55,
		},
	},
	keys = {
		{ "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" } },
		{ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" } },
		{ "<M-y>", "<Plug>(YankyCycleForward)", mode = "n" },
		{ "<M-p>", "<Plug>(YankyCycleBackward)", mode = "n" },
	},
}
