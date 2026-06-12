return {
	"gbprod/yanky.nvim",
	opts = {
		highlight = {
			on_yank = false,
			on_put = false,
		},
	},
	keys = {
		{ "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" } },
		{ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" } },
		{ "<M-y>", "<Plug>(YankyCycleForward)", mode = "n" },
		{ "<M-S-p>", "<Plug>(YankyCycleBackward)", mode = "n" },
		-- Insert mode mappings
		{ "<C-y>", "<C-o><Plug>(YankyPutAfter)", mode = "i", desc = "Put from Yanky" },
		{ "<M-y>", "<C-o><Plug>(YankyCycleForward)", mode = "i", desc = "Cycle Yanky Forward" },
		{ "<M-S-p>", "<C-o><Plug>(YankyCycleBackward)", mode = "i", desc = "Cycle Yanky Backward" },
	},
}
