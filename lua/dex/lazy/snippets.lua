return {
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",

		dependencies = { "rafamadriz/friendly-snippets" },

		config = function()
			local ls = require("luasnip")

			-- This is the only essential line: loads all snippets for use by nvim-cmp
			require("luasnip.loaders.from_vscode").lazy_load()

			-- This line is safe to keep if you ever deal with JavaScript documentation
			ls.filetype_extend("javascript", { "jsdoc" })

			-- ALL CUSTOM KEYMAPS ARE REMOVED because nvim-cmp handles expansion and jumping.
		end,
	},
}
