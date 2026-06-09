require("dex")

vim.keymap.set("n", "<leader><leader>", "v", { silent = true })
vim.keymap.set("n", "<leader>v", "V", { silent = true })


local function duplicate_smart()
  local mode = vim.api.nvim_get_mode().mode

  -- If we are in any Visual Mode (v, V, or Ctrl-V)
  if mode:match("[vV\22]") then
    -- 1. Exit visual mode to save the marks ('< and '>)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)

    vim.schedule(function()
      -- 2. Get the start and end line numbers
      local start_line = vim.api.nvim_buf_get_mark(0, "<")[1]
      local end_line = vim.api.nvim_buf_get_mark(0, ">")[1]

      -- 3. Get all lines in the selection
      -- (0-indexed, so start_line-1. end_line is inclusive in this API)
      local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

      -- 4. Insert the block of lines directly below the selection
      vim.api.nvim_buf_set_lines(0, end_line, end_line, false, lines)

      -- 5. Move cursor to the first line of the new duplicate
      vim.api.nvim_win_set_cursor(0, {end_line + 1, 0})
    end)
  else
    -- NORMAL MODE: Duplicate the current line (Your original logic)
    local cursor = vim.api.nvim_win_get_cursor(0)
    local line_content = vim.api.nvim_get_current_line()

    -- Insert the line below
    vim.api.nvim_buf_set_lines(0, cursor[1], cursor[1], false, {line_content})

    -- Move cursor to the new line, keeping the same column
    vim.api.nvim_win_set_cursor(0, {cursor[1] + 1, cursor[2]})
  end
end

-- Keybindings
vim.keymap.set('n', '<leader>,', duplicate_smart, { desc = 'Duplicate line' })
vim.keymap.set('i', '<C-x>,', duplicate_smart, { desc = 'Duplicate line' })
vim.keymap.set('v', '<leader>,', duplicate_smart, { desc = 'Duplicate selection' })







