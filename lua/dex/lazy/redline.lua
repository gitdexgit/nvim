return {
	"hiberabyss/readline.nvim",
	config = function()
		local readline = require("readline")

		vim.keymap.set("i", "<C-k>", function()
			local row, col = unpack(vim.api.nvim_win_get_cursor(0))
			row = row - 1 -- Adjust to 0-indexed for API
			local line = vim.api.nvim_get_current_line()

			if col >= #line then
				-- At EOL: Join next line by deleting the newline character
				local total_lines = vim.api.nvim_buf_line_count(0)
				if row + 1 < total_lines then
					-- This deletes the invisible newline at the end of 'row'
					vim.api.nvim_buf_set_text(0, row, col, row + 1, 0, {})
				end
			else
				-- Mid-line: Use plugin to kill to EOL
				readline.kill_line()
			end
		end, { desc = "Emacs C-k (API Join)" })
	end,
}
