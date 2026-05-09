-- ~/.config/nvim/lua/dex/clipboard.lua
local function tmux_system_copy(lines)
	local str = table.concat(lines, "\n")
	local copy_command = "tmux load-buffer -w - && tmux show-buffer | xclip -selection clipboard"
	vim.fn.system(copy_command, str)
	local job = vim.fn.jobstart(
		"ssh -o ConnectTimeout=1 -i ~/.ssh/id_ed25519 -p 8022 u0_a662@100.126.224.121 termux-clipboard-set",
		{ detach = true }
	)
	vim.fn.chansend(job, str)
	vim.fn.chanclose(job, "stdin")
end

local function tmux_system_paste()
	local paste_command = "xclip -selection clipboard -o || tmux save-buffer -"
	local result = vim.fn.systemlist(paste_command)
	return result
end

vim.g.clipboard = {
	name = "tmux-popup-bridge",
	copy = {
		["+"] = tmux_system_copy,
		["*"] = tmux_system_copy,
	},
	paste = {
		["+"] = tmux_system_paste,
		["*"] = tmux_system_paste,
	},
	cache_enabled = 1,
}

if os.getenv("UVIM_MODE") == "true" then
	vim.opt.clipboard = ""
	vim.opt.lazyredraw = true
end
