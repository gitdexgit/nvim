return {
	{
		"ibhagwan/fzf-lua",
		-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional for icons
		config = function()
			-- 1. Setup Fzf-lua
			require("fzf-lua").setup({
				winopts = {
					fullscreen = true,
					preview = {
						layout = "vertical",
						vertical = "up:70%",
					},
				},

				-- use exact string matching, but only for the files picker
				files = {
					fzf_opts = {
						["--exact"] = false,
						["--no-sort"] = false,
					},
				},

				keymap = {
					builtin = {
						-- Use your Alt-j / Alt-k scrolling logic
						-- ["<C-u>"] = "preview-page-up",
						-- ["<C-d>"] = "preview-page-down",
						-- ["<C-g>"] = "preview-page-up",
						-- ["<C-b>"] = "preview-page-up",
						-- ["<C-f>"] = "preview-page-down",
						-- ["<C-e>"] = "preview-down",
						-- ["<C-y>"] = "preview-up",
						["<M-j>"] = "preview-down",
						["<M-k>"] = "preview-up",
						["<M-S-j>"] = "preview-page-down",
						["<M-S-k>"] = "preview-page-up",
					},

					fzf = {
						["ctrl-q"] = "select-all+accept",
						-- ["ctrl-j"] = "down",
						-- ["ctrl-k"] = "up",
						-- add these:
						-- ["ctrl-u"] = "preview-page-up",
						-- ["ctrl-d"] = "preview-page-down",
						-- ["ctrl-f"] = "preview-page-down",
						-- ["ctrl-b"] = "preview-page-down",
						-- ["ctrl-g"] = "preview-page-up",
						["alt-j"] = "preview-down",
						["alt-k"] = "preview-up",
						-- ["alt-n"] = "down",
						-- ["alt-p"] = "up",
					},
				},
			})

			-- Searches everything. But .gitignores applie
			vim.keymap.set(
				"n",
				"<leader>fp",
				require("fzf-lua").files,
				{ noremap = true, silent = true, desc = "FZF-Lua: Find Files" }
			)

			-- Searches only .git files being tracked. So .gitignores is useful to exclude files you don't want to see.
			vim.keymap.set(
				"n",
				"<C-p>",
				require("fzf-lua").git_files,
				{ noremap = true, silent = true, desc = "FZF-Lua: Builtin/Help" }
			)

			-- Searches everything. .gitignores don't apply
			vim.keymap.set("n", "<leader>pf", function()
				require("fzf-lua").files({
					-- if using fd
					fd_opts = "--type f --hidden --no-ignore --exclude .git",
					-- if using rg
					rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --e --files --hidden --no-ignore",
				})
			end, { desc = "FZF-Lua: All Files" })

			-- Highlight something it will put it in the buffer search.
			vim.keymap.set("v", "<leader>/", function()
				-- 1. Exit visual mode to set '< and '> marks
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "x", false)

				-- 2. Grab text between marks (0-indexed)
				local s = vim.fn.getpos("'<")
				local e = vim.fn.getpos("'>")

				-- nvim_buf_get_text(buf, start_row, start_col, end_row, end_col, opts)
				local lines = vim.api.nvim_buf_get_text(0, s[2] - 1, s[3] - 1, e[2] - 1, e[3], {})
				local query = table.concat(lines, " "):gsub("%s+", " ")

				-- 3. Search in buffer
				require("fzf-lua").blines({ query = query })
			end, { noremap = true, silent = true, desc = "FZF-Lua: Search selection (No Registers)" })

			vim.keymap.set(
				"n",
				"<leader>pq",
				require("fzf-lua").quickfix,
				{ noremap = true, silent = true, desc = "FZF-Lua: Quickfix" }
			)
			vim.keymap.set(
				"n",
				"<leader>/",
				require("fzf-lua").blines,
				{ noremap = true, silent = true, desc = "FZF-Lua: Find In Current blines" }
			)
			vim.keymap.set(
				"n",
				"<leader>fq",
				require("fzf-lua").quickfix,
				{ noremap = true, silent = true, desc = "FZF-Lua: Quickfix" }
			)

			vim.keymap.set(
				"n",
				"<leader>fiW",
				require("fzf-lua").grep_cWORD,
				{ noremap = true, silent = true, desc = "FZF-Lua: Find In Current Buffer" }
			)

			vim.keymap.set(
				"n",
				"<leader>lg",
				require("fzf-lua").live_grep,
				{ noremap = true, silent = true, desc = "FZF-Lua: Live Grep" }
			)

			vim.keymap.set(
				"n",
				"<leader>r",
				require("fzf-lua").registers,
				{ noremap = true, silent = true, desc = "FZF-Lua: registers" }
			)

			-- Harpoon + FZF
			vim.keymap.set("n", "<leader>ph", function()
				local harpoon = require("harpoon")
				local harpoon_list = harpoon:list()
				local items = harpoon_list:display()

				require("fzf-lua").fzf_exec(items, {
					prompt = "Harpoon> ",
					cwd = vim.fn.getcwd(),
					previewer = "builtin",
					actions = {
						["default"] = function(selected)
							for i, item in ipairs(items) do
								if item == selected[1] then
									harpoon_list:select(i)
									break
								end
							end
						end,
					},
				})
			end, { desc = "Harpoon: FZF Search" })

			vim.keymap.set("n", "<leader>fh", function()
				local harpoon = require("harpoon")
				local harpoon_list = harpoon:list()
				local items = harpoon_list:display()

				require("fzf-lua").fzf_exec(items, {
					prompt = "Harpoon> ",
					cwd = vim.fn.getcwd(),
					previewer = "builtin",
					actions = {
						["default"] = function(selected)
							for i, item in ipairs(items) do
								if item == selected[1] then
									harpoon_list:select(i)
									break
								end
							end
						end,
					},
				})
			end, { desc = "Harpoon: FZF Search" })

			vim.keymap.set("v", "<leader>r", function()
				vim.cmd('normal! "_d')
				vim.schedule(function()
					require("fzf-lua").registers()
				end)
			end, { noremap = true, silent = true, desc = "Replace selection with register" })
			vim.keymap.set(
				"n",
				"<leader>pb",
				require("fzf-lua").buffers,
				{ noremap = true, silent = true, desc = "FZF-Lua: Buffers" }
			)
			vim.keymap.set(
				"n",
				"<leader>fb",
				require("fzf-lua").buffers,
				{ noremap = true, silent = true, desc = "FZF-Lua: Buffers" }
			)
			vim.keymap.set(
				"n",
				"<leader>fo",
				require("fzf-lua").oldfiles,
				{ noremap = true, silent = true, desc = "FZF-Lua: Buffers" }
			)

			-- Normal Mode
			vim.keymap.set(
				"n",
				"<C-x>b",
				require("fzf-lua").buffers,
				{ noremap = true, silent = true, desc = "FZF-Lua: Buffers" }
			)

			-- Insert Mode
			vim.keymap.set("i", "<C-x>b", function()
				-- Use C-o to trigger from insert
				vim.cmd("stopinsert")
				require("fzf-lua").buffers()
			end, { noremap = true, silent = true, desc = "FZF-Lua: Buffers" })

			vim.keymap.set(
				"n",
				"<leader>g/",
				require("fzf-lua").grep_project,
				{ noremap = true, silent = true, desc = "FZF-Lua: Grep Current CWD Projects" }
			)

			vim.keymap.set("v", "<leader>g/", function()
				-- 1. Exit visual mode
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "x", false)

				-- 2. Get text via API
				local s = vim.fn.getpos("'<")
				local e = vim.fn.getpos("'>")
				local lines = vim.api.nvim_buf_get_text(0, s[2] - 1, s[3] - 1, e[2] - 1, e[3], {})
				local query = table.concat(lines, " "):gsub("%s+", " ")

				-- 3. Grep project (uses 'search' for grep pattern)
				require("fzf-lua").grep_project({ search = query })
			end, { noremap = true, silent = true, desc = "FZF-Lua: Grep selection in project" })

			-- Open the last fzf-lua thing you did. So you don't lose it. if you exit without meaning it
			vim.keymap.set(
				"n",
				"<leader>;",
				require("fzf-lua").resume,
				{ noremap = true, silent = true, desc = "FZF-Lua: Resume" }
			)

			-- fzf-lua marks
			vim.keymap.set(
				"n",
				"<leader>m",
				require("fzf-lua").marks,
				{ noremap = true, silent = true, desc = "FZF-Lua: Marks" }
			)

			vim.keymap.set(
				"n",
				"<leader>J",
				require("fzf-lua").jumps,
				{ noremap = true, silent = true, desc = "FZF-Lua: Marks" }
			)

			vim.keymap.set(
				"n",
				"<leader>?",
				require("fzf-lua").builtin,
				{ noremap = true, silent = true, desc = "FZF-Lua: Builtin/Help" }
			)
			vim.keymap.set(
				"n",
				"<leader>ch",
				require("fzf-lua").command_history,
				{ noremap = true, silent = true, desc = "FZF-Lua: Marks" }
			)
			vim.keymap.set(
				"n",
				"<leader>fdd",
				require("fzf-lua").diagnostics_document,
				{ noremap = true, silent = true, desc = "FZF-Lua: Marks" }
			)
			vim.keymap.set(
				"n",
				"<leader>fdw",
				require("fzf-lua").diagnostics_workspace,
				{ noremap = true, silent = true, desc = "FZF-Lua: Marks" }
			)
			vim.keymap.set(
				"n",
				"<leader>dap",
				require("fzf-lua").dap_commands,
				{ noremap = true, silent = true, desc = "FZF-Lua: Marks" }
			)
			vim.keymap.set(
				"n",
				"<leader>cc",
				require("fzf-lua").commands,
				{ noremap = true, silent = true, desc = "FZF-Lua: Marks" }
			)
			vim.keymap.set(
				"n",
				"<leader>fc",
				require("fzf-lua").changes,
				{ noremap = true, silent = true, desc = "FZF-Lua: Marks" }
			)

			vim.keymap.set(
				"v",
				"<leader>?",
				require("fzf-lua").builtin,
				{ noremap = true, silent = true, desc = "FZF-Lua: Builtin/Help" }
			)
		end,
	},
}
