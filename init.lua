-- 1. Set the local leader to comma
-- This makes ,ee, ,eb, etc. work out of the box
vim.g.maplocalleader = ","
vim.g.mapleader = " "
vim.opt.splitbelow = true

require("dex")

-- I used to find this cool but it's whatever it's meh I'll keep it for whatever as comment
-- But for prime I'll keep this for whatever reason why not.
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")


-- Normal Mode
vim.keymap.set('n', '<A-n>', ':m .+1<CR>==', { silent = true })
vim.keymap.set('n', '<A-p>', ':m .-2<CR>==', { silent = true })

-- Insert Mode
vim.keymap.set('i', '<A-n>', '<Esc>:m .+1<CR>==gi', { silent = true })
vim.keymap.set('i', '<A-p>', '<Esc>:m .-2<CR>==gi', { silent = true })


-- vim.keymap.set("n", "<leader><leader>", "v", { silent = true })
vim.keymap.set("v", "<leader>v", "V", { silent = true })
-- vim.keymap.set("v", "<leader><leader>", "v", { silent = true })
vim.keymap.set("v", "<C-Space>", "v")
vim.keymap.set("n", "<leader>v", "V", { silent = true })

-- Keep tabs hidden forever
vim.opt.showtabline = 0

-- Enable terminal title setting (so nvim sends OSC 0 to vterm)
vim.o.title = true

-- Format: filename [modified] - line,column
vim.o.titlestring = "%f %m - %l,%c"

-- Force title update on cursor move (so line/col updates instantly)
vim.api.nvim_create_autocmd("CursorMoved", {
	pattern = "*",
	callback = function()
		vim.o.titlestring = "%f %m - %l,%c"
	end,
})

-- Also update title when buffer changes (e.g., :w)
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*",
	callback = function()
		vim.o.titlestring = "%f %m - %l,%c"
	end,
})

vim.o.title = true
local function update_title()
	local fname = vim.fn.expand("%:t")
	if fname == "" then
		fname = "[No Name]"
	end
	local mod = vim.bo.modified and " +" or ""
	local line = vim.fn.line(".")
	local col = vim.fn.col(".")
	vim.o.titlestring = string.format("%s%s - %d,%d", fname, mod, line, col)
end
vim.api.nvim_create_autocmd({ "CursorMoved", "BufWritePost", "BufEnter" }, { callback = update_title })
update_title()

local bars_on = true
function _G.toggle_bars()
	if bars_on then
		vim.opt.laststatus = 0
		bars_on = false
	else
		-- Only show the bottom bar
		vim.opt.laststatus = 3
		bars_on = true
	end
end

vim.keymap.set("n", "<leader>z", _G.toggle_bars)

-- vim.opt.title = true
-- -- Shows: filename line:column
-- vim.opt.titlestring = "%f %m - %l,%c"
