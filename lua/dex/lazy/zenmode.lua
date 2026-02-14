return {
	"folke/zen-mode.nvim",
	config = function()
		local zen = require("zen-mode")




-- Manual zen mode that doesn't suck and works with context tree sitter
local manual_zen = false

vim.keymap.set("n", "<leader>zz", function()
    manual_zen = not manual_zen

    if manual_zen then
        -- ENTERING ZEN
        vim.opt.laststatus = 0              -- Hide status bar
        vim.opt.showmode = false            -- Hide -- INSERT --
        vim.opt.ruler = false               -- Hide line/col numbers at bottom
        vim.opt.fillchars:append({ eob = " " }) -- Hide those ~ scwiglly lines
        vim.opt.scrolloff = 999             -- Typewriter scroll
        vim.opt.cmdheight = 0               -- Hide the command line area (makes bottom black)
    else
        -- EXITING ZEN
        vim.opt.laststatus = 3              -- Restore status bar
        vim.opt.showmode = true
        vim.opt.ruler = true
        vim.opt.fillchars:append({ eob = "~" }) -- Restore ~ lines
        vim.opt.scrolloff = 8
        vim.opt.cmdheight = 1               -- Restore command line area
    end
end, { desc = "Clean Manual Zen" })


		-- -- 1. LEVEL 1: Coding Mode
		-- vim.keymap.set("n", "<leader>zz", function()
		-- 	require("zen-mode").setup({
		-- 		window = {
		-- 			width = 1,
		-- 			options = {
		-- 				number = true,
		-- 				relativenumber = true,
		-- 				signcolumn = "yes",
		-- 			},
		-- 		},
		-- 		on_open = function()
		-- 			vim.opt.scrolloff = 999
		-- 		end,
		-- 		on_close = function()
		-- 			vim.opt.scrolloff = 8
		-- 			ColorMyPencils()
		-- 		end,
		-- 	})
		-- 	require("zen-mode").toggle()
		-- end, { desc = "Zen: Coding Mode (Numbers + Typewriter)" })
		--
		--

-- Manual zen mode that doesn't suck and works with context tree sitter
local manual_zen = false

vim.keymap.set("n", "<leader>zZ", function()
    manual_zen = not manual_zen

    if manual_zen then
        -- ENTERING ZEN
        vim.opt.number = false              -- Hide line numbers
        vim.opt.relativenumber = false      -- Hide relative numbers
        vim.opt.signcolumn = "no"           -- Hide the side column (git signs/errors)

        vim.opt.laststatus = 0              -- Hide status bar
        vim.opt.showmode = false            -- Hide -- INSERT --
        vim.opt.ruler = false               -- Hide coordinates
        vim.opt.fillchars:append({ eob = " " }) -- Hide those ~ lines
        vim.opt.scrolloff = 999             -- Typewriter scroll
        vim.opt.cmdheight = 0               -- Hide the command line area
    else
        -- EXITING ZEN (Restores everything to normal)
        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.opt.signcolumn = "yes"

        vim.opt.laststatus = 3
        vim.opt.showmode = true
        vim.opt.ruler = true
        vim.opt.fillchars:append({ eob = "~" })
        vim.opt.scrolloff = 8
        vim.opt.cmdheight = 1
    end
end, { desc = "Clean Zen (No Numbers + Context Friendly)" })

		-- 2. LEVEL 2: Standard Zen
		-- vim.keymap.set("n", "<leader>zZ", function()
		-- 	require("zen-mode").setup({
		-- 		window = {
		-- 			width = 1,
		-- 			options = {
		-- 				number = false,
		-- 				relativenumber = false,
		-- 				signcolumn = "no",
		-- 				colorcolumn = "0",
		-- 			},
		-- 		},
		-- 		on_open = function()
		-- 			vim.opt.scrolloff = 0
		-- 		end,
		-- 		on_close = function()
		-- 			vim.opt.scrolloff = 8
		-- 			ColorMyPencils()
		-- 		end,
		-- 	})
		-- 	require("zen-mode").toggle()
		-- end, { desc = "Zen: Standard (No Numbers + Emacs Scroll)" })

		-- 3. LEVEL 3: THE SEMI-VOID (Fixed to prevent crashes)
		vim.keymap.set("n", "<leader>Zz", function()
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
				on_open = function()
					-- FIX: Disable context before killing treesitter
					pcall(vim.cmd, "TSContextDisable")

					vim.opt.scrolloff = 999
					vim.cmd("syntax off")
					pcall(vim.treesitter.stop)
					vim.opt.cmdheight = 0
					for _, client in ipairs(vim.lsp.get_active_clients()) do
						client.server_capabilities.semanticTokensProvider = nil
					end
				end,
				on_close = function()
					-- FIX: Re-enable context
					pcall(vim.cmd, "TSContextEnable")

					vim.opt.scrolloff = 8
					vim.cmd("syntax on")
					pcall(vim.treesitter.start)
					vim.opt.cmdheight = 1
					ColorMyPencils()
				end,
			})
			require("zen-mode").toggle()
		end, { desc = "Zen: Semi-Void (Typewriter Center)" })


-- special
		vim.keymap.set("n", "<leader>ZD", function()
			require("zen-mode").setup({
				window = {
					width = 1,
					options = {
						number = false,
						relativenumber = false,
						signcolumn = "no",
						cursorline = false,
						laststatus = 0,
					},
				},
				on_open = function()
					-- Disable context (sticky scroll)
					pcall(vim.cmd, "TSContextDisable")

					vim.opt.scrolloff = 999
					vim.opt.cmdheight = 0
					-- Syntax, Treesitter, and LSP tokens remain ENABLED here
				end,
				on_close = function()
					-- Re-enable context
					pcall(vim.cmd, "TSContextEnable")

					vim.opt.scrolloff = 8
					vim.opt.cmdheight = 1
					ColorMyPencils()
				end,
			})
			require("zen-mode").toggle()
		end, { desc = "Zen: Semi-Void (Typewriter Center)" })

		-- 4. LEVEL 4: THE FULL VOID (Fixed to prevent crashes)
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
					-- FIX: Disable context before killing treesitter
					pcall(vim.cmd, "TSContextDisable")

					vim.opt.scrolloff = 999
					vim.fn.system("tmux set status off")
					vim.fn.system("tmux list-panes -F '#F' | grep -q Z || tmux resize-pane -Z")
					vim.cmd("syntax off")
					pcall(vim.treesitter.stop)
					vim.opt.cmdheight = 0

					for _, client in ipairs(vim.lsp.get_active_clients()) do
						client.server_capabilities.semanticTokensProvider = nil
					end
				end,
				on_close = function()
					-- FIX: Re-enable context
					pcall(vim.cmd, "TSContextEnable")

					vim.opt.scrolloff = 8
					vim.fn.system("tmux set status on")
					vim.fn.system("tmux list-panes -F '#F' | grep -q Z && tmux resize-pane -Z")
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
