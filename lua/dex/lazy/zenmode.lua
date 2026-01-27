return {
	"folke/zen-mode.nvim",
	config = function()
		local zen = require("zen-mode")

		vim.keymap.set("n", "<leader>zz", function()
			require("zen-mode").setup({
				window = {
					width = 1,
					options = {
						number = true,
						relativenumber = true,
						signcolumn = "yes",
					},
				},
				on_open = function()
					vim.opt.scrolloff = 999 -- Center the cursor
				end,
				on_close = function()
					vim.opt.scrolloff = 8 -- Back to your set.lua default
					ColorMyPencils()
				end,
			})
			require("zen-mode").toggle()
		end, { desc = "Zen: Coding Mode (Numbers + Typewriter)" })

		-- 2. LEVEL 2: Default Zen (No Numbers + Emacs Scroll)
		vim.keymap.set("n", "<leader>zZ", function()
			require("zen-mode").setup({
				window = {
					width = 1, -- Keeps code on the left
					options = {
						number = false,
						relativenumber = false,
						signcolumn = "no",
						colorcolumn = "0",
					},
				},
				on_open = function()
					-- EMACS STYLE: Use the full height of the screen
					vim.opt.scrolloff = 0
				end,
				on_close = function()
					-- RESET: Return to your set.lua default (8)
					vim.opt.scrolloff = 8
					ColorMyPencils()
				end,
			})
			require("zen-mode").toggle()
		end, { desc = "Zen: Standard (No Numbers + Emacs Scroll)" })

		-- 3. LEVEL 3: THE SEMI-VOID (No Color + TMUX Visible + Typewriter)
		vim.keymap.set("n", "<leader>Zz", function()
			require("zen-mode").setup({
				window = {
					width = 80, -- Centered column
					options = {
						number = false,
						relativenumber = false,
						signcolumn = "no",
						cursorline = false,
						laststatus = 0,
					},
				},
				on_open = function()
					-- THE SYNERGY: Horizontal Centering + Vertical Centering
					vim.opt.scrolloff = 999

					vim.cmd("syntax off")
					pcall(vim.treesitter.stop)
					vim.opt.cmdheight = 0
					for _, client in ipairs(vim.lsp.get_active_clients()) do
						client.server_capabilities.semanticTokensProvider = nil
					end
				end,
				on_close = function()
					vim.opt.scrolloff = 8
					vim.cmd("syntax on")
					pcall(vim.treesitter.start)
					vim.opt.cmdheight = 1
					ColorMyPencils()
				end,
			})
			require("zen-mode").toggle()
		end, { desc = "Zen: Semi-Void (Typewriter Center)" })

		-- 4. LEVEL 4: THE FULL VOID (No Color + No Tmux + Typewriter Center)
		vim.keymap.set("n", "<leader>ZZ", function()
			require("zen-mode").setup({
				window = {
					width = 80,
					options = {
						number = false,
						relativenumber = false,
						signcolumn = "no",
						cursorline = false,
						laststatus = 0,
					},
				},
				plugins = {
					gitsigns = { enabled = false },
					tmux = { enabled = false },
				},
				on_open = function()
					-- 1. TYPEWRITER: Lock cursor in vertical center
					vim.opt.scrolloff = 999

					-- 2. TMUX: Hide status bar and zoom pane
					vim.fn.system("tmux set status off")
					vim.fn.system("tmux list-panes -F '#F' | grep -q Z || tmux resize-pane -Z")

					-- 3. NEOVIM: Kill UI and Colors
					vim.cmd("syntax off")
					pcall(vim.treesitter.stop)
					vim.opt.cmdheight = 0

					for _, client in ipairs(vim.lsp.get_active_clients()) do
						client.server_capabilities.semanticTokensProvider = nil
					end
				end,
				on_close = function()
					-- 1. RESET SCROLL: Return to your set.lua default (8)
					vim.opt.scrolloff = 8

					-- 2. RESTORE TMUX: Bring bar back and un-zoom
					vim.fn.system("tmux set status on")
					vim.fn.system("tmux list-panes -F '#F' | grep -q Z && tmux resize-pane -Z")

					-- 3. RESTORE NEOVIM: Bring back colors and UI
					vim.cmd("syntax on")
					pcall(vim.treesitter.start)
					vim.opt.cmdheight = 1
					ColorMyPencils()
				end,
			})
			require("zen-mode").toggle()
		end, { desc = "Zen: THE VOID (Typewriter Center + No Tmux)" })
	end,
}
