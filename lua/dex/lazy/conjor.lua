return {
  {
    "Olical/conjure",
    ft = { "scheme", "clojure", "lisp" },
    lazy = true,
    init = function()
      -- 1. This kills the HUD (the heads-up display)
      vim.g["conjure#hud#enabled"] = false

      -- 2. This kills the log HUD (the tiny popup that shows results/errors)
      -- This is usually the one people hate the most
      vim.g["conjure#log#hud#enabled"] = false

      -- 3. This stops the log from jumping open on every little thing
      vim.g["conjure#log#auto_close_visible"] = false

      -- Your Guile command
      vim.g["conjure#client#scheme#stdio#command"] = "guile"
    end,
  },
}
