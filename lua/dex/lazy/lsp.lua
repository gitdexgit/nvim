local root_files = {
	".luarc.json",
	".luarc.jsonc",
	".luacheckrc",
	".stylua.toml",
	"stylua.toml",
	"selene.toml",
	"selene.yml",
	".git",
}

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"stevearc/conform.nvim",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
	},

	config = function()
		require("conform").setup({
			formatters_by_ft = {},
		})
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)

		require("fidget").setup({})
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				-- "clangd",
				"pyright",
			},
			handlers = {
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,
				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								format = {
									enable = true,
									-- Put format options here
									-- NOTE: the value should be STRING!!
									defaultConfig = {
										indent_style = "space",
										indent_size = "2",
									},
								},
							},
						},
					})
				end,
			},
		})

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
				-- ADD THESE TWO LINES:
				["<C-u>"] = cmp.mapping.scroll_docs(-4),
				["<C-d>"] = cmp.mapping.scroll_docs(4),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- For luasnip users.
                { name = "path"},
			}, {
				{ name = "buffer" },
			}),
		})

		vim.diagnostic.config({
			-- update_in_insert = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})



--- > @ai """well heere goes nothing""" START

local api = vim.api

-- The "Smart Redirect" Function
-- It finds a focusable float (the Hover), scrolls it, or falls back to your code.
local function scroll_float(key_code)
    return function()
        local winid = nil
        -- 1. Look for the focusable floating window (LSP Documentation)
        for _, win in ipairs(api.nvim_tabpage_list_wins(0)) do
            local config = api.nvim_win_get_config(win)
            if config.relative ~= "" and config.focusable then
                winid = win
                break
            end
        end

        if winid then
            -- 2. REDIRECT: Send the scroll command into the Hover window
            api.nvim_win_call(winid, function()
                vim.cmd("normal! " .. key_code)
            end)
        else
            -- 3. FALLBACK: No float open? Scroll your main code buffer instead.
            local codes = api.nvim_replace_termcodes(key_code, true, false, true)
            api.nvim_feedkeys(codes, "n", true)
        end
    end
end

-- 1. Line-by-Line (Precision)
vim.keymap.set("n", "<C-e>", scroll_float("\x05"), { desc = "Scroll float/buffer 1 line down" })
vim.keymap.set("n", "<C-y>", scroll_float("\x19"), { desc = "Scroll float/buffer 1 line up" })

-- 2. Half-Page (Standard Speed)
vim.keymap.set("n", "<C-d>", scroll_float("\x04"), { desc = "Scroll float/buffer half-page down" })
vim.keymap.set("n", "<C-u>", scroll_float("\x15"), { desc = "Scroll float/buffer half-page up" })

-- 3. Full-Page (Big Jumps)
vim.keymap.set("n", "<C-f>", scroll_float("\x06"), { desc = "Scroll float/buffer full-page down" })
vim.keymap.set("n", "<C-b>", scroll_float("\x02"), { desc = "Scroll float/buffer full-page up" })


--- > @ai """well heere goes nothing""" END

        -- -- Map the scrolling keys in Normal mode
        -- vim.keymap.set("n", "<C-f>", scroll_float("down"), { desc = "Scroll hover down" })
        -- vim.keymap.set("n", "<C-b>", scroll_float("up"), { desc = "Scroll hover up" })

	end,
}
