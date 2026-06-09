--- TODO: LLM failed to make this today 2026-06-08_18-56-57
---
--- https://i.imgur.com/4VYgCCR.png
--- make the:
--- drwxr-xr-x 12.0k Jun 07 16:13 dex dex   ../
--- drwxr-xr-x 4.0k Jun 08 15:48 dex dex   ./
--- render at the top but that's for a latter time. maybe tommorrow ok.
--- Github(I ask for feature request):
--- https://github.com/stevearc/oil.nvim/issues/758

local user_cache = {}
local group_cache = {}
local header_ns = vim.api.nvim_create_namespace("oil_header")

local function get_user(uid)
	if not uid then
		return "-"
	end
	if not user_cache[uid] then
		local name = vim.fn.trim(vim.fn.system("id -un " .. uid))
		user_cache[uid] = (vim.v.shell_error == 0) and name or tostring(uid)
	end
	return user_cache[uid]
end

local function get_group(gid)
	if not gid then
		return "-"
	end
	if not group_cache[gid] then
		local name = vim.fn.trim(vim.fn.system("id -gn " .. gid))
		group_cache[gid] = (vim.v.shell_error == 0) and name or tostring(gid)
	end
	return group_cache[gid]
end

local function get_perms(mode)
	local chars = { "r", "w", "x" }
	local str = (bit.band(mode, 0x4000) ~= 0) and "d" or "-"
	for i = 6, 0, -3 do
		local bits = bit.rshift(mode, i)
		for j = 1, 3 do
			str = str .. ((bit.band(bits, bit.lshift(1, 3 - j)) ~= 0) and chars[j] or "-")
		end
	end
	return str
end

local function format_size(b)
	if not b then
		return "0B"
	end
	if b < 1024 then
		return b .. "B"
	end
	if b < 1048576 then
		return string.format("%.1fK", b / 1024)
	end
	return string.format("%.1fM", b / 1048576)
end

local function update_oil_header()
	if vim.bo.filetype ~= "oil" then
		return
	end
	local ok, oil = pcall(require, "oil")
	if not ok then
		return
	end
	local dir = oil.get_current_dir()
	if not dir then
		return
	end
	local raw_path = vim.fn.fnamemodify(dir:gsub("^oil://", ""), ":p")
	local stat_curr = vim.uv.fs_stat(raw_path)
	local stat_parent = vim.uv.fs_stat(raw_path .. "..")
	if not stat_curr then
		return
	end
	vim.api.nvim_buf_clear_namespace(0, header_ns, 0, -1)
	local function format_line(stat, name)
		local perms = get_perms(stat.mode)
		local user = get_user(stat.uid)
		local group = get_group(stat.gid)
		local size = format_size(stat.size)
		local time = os.date("%b %d %H:%M", stat.mtime.sec)
		return string.format("%s %s %s %s %s   %s", perms, size, time, user, group, name)
	end
	local lines = {}
	if stat_parent then
		table.insert(lines, { { format_line(stat_parent, "../"), "NonText" } })
	end
	table.insert(lines, { { format_line(stat_curr, "./"), "NonText" } })
	if vim.api.nvim_buf_line_count(0) > 0 then
		vim.api.nvim_buf_set_extmark(0, header_ns, 0, 0, {
			virt_lines = lines,
			virt_lines_above = true,
			priority = 1000,
		})
	end
end

_G.get_oil_winbar = function()
	local ok, oil = pcall(require, "oil")
	return ok and (oil.get_current_dir() or ""):gsub("^oil://", "") or ""
end

local function dired_prompt(opts)
	opts = opts or {}
	local oil = require("oil")
	local fzf = require("fzf-lua")
	local dir = opts.dir or (oil.get_current_dir() or vim.fn.getcwd()):gsub("^oil://", "")
	dir = vim.fn.fnamemodify(dir, ":p")

	fzf.fzf_exec("fd --type d --max-depth 1 --hidden --exclude .git", {
		cwd = dir,
		query = opts.query,
		prompt = "Dired [" .. vim.fn.fnamemodify(dir, ":~") .. "]> ",
		previewer = "builtin",
		actions = {
			["default"] = function(selected)
				if not selected or #selected == 0 then
					return
				end
				oil.open(dir .. selected[1])
			end,
			["tab"] = function(selected)
				if not selected or #selected == 0 then
					return
				end
				dired_prompt({ dir = dir .. selected[1] })
			end,
			["backspace"] = function(_, fzf_opts)
				if fzf_opts.last_query == "" then
					local parent = vim.fn.fnamemodify(dir, ":h:h") .. "/"
					dired_prompt({ dir = parent })
				else
					local new_q = fzf_opts.last_query:sub(1, -2)
					dired_prompt({ dir = dir, query = new_q })
				end
			end,
		},
	})
end

return {

	{
		"handy-sun/wilder.nvim",
		dependencies = { "romgrk/fzy-lua-native" },
		build = ":UpdateRemotePlugins",
		lazy = false,
		config = function()
			local wilder = require("wilder")
			wilder.setup({
				modes = { ":", "/", "?" },
				use_python_remote_plugin = 0,
			})

			wilder.set_option("noselect", 0)

			-- Tab: Pick first match
			vim.api.nvim_set_keymap(
				"c",
				"<Tab>",
				'wilder#in_context() ? wilder#accept_completion() : "\\<Tab>"',
				{ expr = true, noremap = true }
			)

			-- Navigation
			local opts = { expr = true, noremap = true }
			vim.api.nvim_set_keymap("c", "<C-f>", 'wilder#in_context() ? wilder#next() : "\\<C-f>"', opts)
			vim.api.nvim_set_keymap("c", "<C-b>", 'wilder#in_context() ? wilder#previous() : "\\<C-b>"', opts)
			vim.api.nvim_set_keymap("c", "<Right>", 'wilder#in_context() ? wilder#next() : "\\<C-f>"', opts)
			vim.api.nvim_set_keymap("c", "<Left>", 'wilder#in_context() ? wilder#previous() : "\\<C-b>"', opts)

			-- Improved Pipeline: fzy filtering
			wilder.set_option("pipeline", {
				wilder.branch(
					wilder.cmdline_pipeline({
						fuzzy = 1,
						set_pcre2_pattern = 1,
					}),
					wilder.vim_search_pipeline({
						-- Fix: use filter, not sorter
						filter = wilder.lua_fzy_filter(),
					})
				),
			})

			-- Improved Renderer: fzy highlighting
			wilder.set_option(
				"renderer",
				wilder.wildmenu_renderer({
					highlighter = wilder.lua_fzy_highlighter(),
					separator = " | ",
					left = { " ", wilder.wildmenu_spinner(), " " },
					right = { " ", wilder.wildmenu_index() },
				})
			)
		end,
	},

	{
		"stevearc/oil.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"ibhagwan/fzf-lua",
		},
		init = function()
			local function smart_delete()
				local cmd = vim.fn.getcmdline()
				local new = vim.fn.substitute(cmd, [[[^/]*/*$]], "", "")
				return vim.api.nvim_replace_termcodes("<C-u>", true, true, true) .. new
			end

			vim.keymap.set({ "n", "i" }, "<C-x>d", dired_prompt)
			vim.keymap.set("n", "<leader>pv", function()
				require("oil").open()
			end)
			vim.keymap.set("c", "<C-BS>", smart_delete, { expr = true })
			vim.keymap.set("c", "<C-h>", smart_delete, { expr = true })

			vim.api.nvim_create_autocmd({ "User", "BufWinEnter" }, {
				callback = function(args)
					if args.event == "User" and args.match ~= "OilRenderPost" then
						return
					end
					vim.schedule(update_oil_header)
				end,
			})
		end,
		opts = {
			win_options = { winbar = "%!v:lua.get_oil_winbar()" },
			columns = {
				"permissions",
				"size",
				"mtime",
				{
					"owner",
					render = function(entry)
						local path = vim.fn.fnamemodify(entry.id:gsub("^oil://", ""), ":p")
						local stat = vim.uv.fs_stat(path)
						return stat and get_user(stat.uid) or "???"
					end,
				},
				{
					"group",
					render = function(entry)
						local path = vim.fn.fnamemodify(entry.id:gsub("^oil://", ""), ":p")
						local stat = vim.uv.fs_stat(path)
						return stat and get_group(stat.gid) or "???"
					end,
				},
				"icon",
			},
			view_options = {
				show_hidden = true,
				is_always_hidden = function()
					return false
				end,
			},
		},
	},
}
