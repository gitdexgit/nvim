return {
	{
		"Olical/conjure",
		ft = { "scheme", "clojure", "lisp" },
		lazy = true,
		init = function()
			vim.g["conjure#filetype#scheme"] = "conjure.client.guile.socket"

			vim.g["conjure#client#guile#socket#pipename"] = vim.fn.getcwd() .. "/.guile-repl.socket"
			vim.g["conjure#hud#enabled"] = false
			vim.g["conjure#log#hud#enabled"] = false
			vim.g["conjure#log#botright"] = true
		end,
		config = function()
			vim.keymap.set("n", ",ls", function()
				local cur_win = vim.api.nvim_get_current_win()
				vim.cmd("ConjureLogSplit")
				vim.api.nvim_set_current_win(cur_win)
			end, { silent = true })
		end,
	},
}
