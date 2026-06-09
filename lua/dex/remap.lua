

vim.api.nvim_set_keymap("c", "<Down>", "<C-n>", { noremap = true })

-- Map window navigation in terminal mode
vim.keymap.set('t', '<C-w>h', [[<C-\><C-n><C-w>h]])
vim.keymap.set('t', '<C-w>j', [[<C-\><C-n><C-w>j]])
vim.keymap.set('t', '<C-w>k', [[<C-\><C-n><C-w>k]])
vim.keymap.set('t', '<C-w>l', [[<C-\><C-n><C-w>l]])
vim.keymap.set('t', '<C-w>w', [[<C-\><C-n><C-w>w]])
vim.keymap.set('t', '<C-w><C-w>', [[<C-\><C-n><C-w><C-w><C-w><C-w>]])

-- making S-u in normal mode useful.
vim.keymap.set("n", "U", "<C-r>")

-- Map Space to do nothing
vim.keymap.set("n", "<Space>", "<Nop>", { noremap = true, silent = true })

-- Map Backspace to do nothing

vim.keymap.set("n", "<BS>", "<Nop>", { noremap = true, silent = true })

vim.keymap.set("i", "<C-Space>", "<C-o>v")
vim.keymap.set("i", "<C-@>", "<C-o>v") -- Fallback for terminal

-- Try this
-- vim.keymap.set("i", "<C-Space>", "<C-o>v", { silent = true })
--
-- vim.keymap.set("i", "<C-@>", "<C-o>v", { silent = true })

vim.g.mapleader = " "
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)






--# <leader>pv is in neo-tree it brings a neo-tree float. because :Ex is stupid with jumplist

-- I used to find this cool but it's whatever it's meh I'll keep it for whatever as comment
-- But for prime I'll keep this for whatever reason why not.
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")


-- Scroll next window down
vim.keymap.set('n', '<M-C-d>', function()
  local next_win = vim.fn.winnr() % vim.fn.winnr('$') + 1
  vim.fn.win_execute(vim.fn.win_getid(next_win), "normal! \4")
end)


vim.keymap.set('n', '<M-C-v>', function()
  local next_win = vim.fn.winnr() % vim.fn.winnr('$') + 1
  vim.fn.win_execute(vim.fn.win_getid(next_win), "normal! \4")
end)











---- sadly <M-C-S-v> Doesn't work in the temrinal So it only works on emacs. I guess





vim.keymap.set('n', '<M-C-u>', function()
  local next_win = vim.fn.winnr() % vim.fn.winnr('$') + 1
  local scroll_up = vim.api.nvim_replace_termcodes("<C-u>", true, false, true)
  vim.fn.win_execute(vim.fn.win_getid(next_win), "normal! " .. scroll_up)
end)


--# i don't understand this <Plug>.... thing is this a lazynvim ? or is this in packer or what
-- vim.api.nvim_set_keymap("n", "<leader>tf", "<Plug>PlenaryTestFile", { noremap = false, silent = false })

vim.keymap.set("n", "<leader>s", "<cmd>setlocal spell!<cr>", { desc = "Toggle spell check" })

vim.keymap.set("n", "<leader>ss", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "J", "mzJ`z")
---just use freaking c-f and c-b
-- vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "z.", "zszH")
--##dummy oh the =ap is for indentation with that indentation plugin conform or sometihng learn that
--# I don't use this as much but I should try it out it's cool it indents stuff
vim.keymap.set("n", "=ap", "ma=ap'a")

vim.keymap.set("n", "<CR>", "<CR>", { noremap = true })

vim.keymap.set('i', '<C-^>', '<C-o><C-^>')








-- =============================================================
-- Emacs insert enhancements
-- =============================================================


_G.emacs_find_file = function()
    local dir = vim.fn.getcwd()
    local ok, oil = pcall(require, "oil")
    if ok then
        local oil_dir = oil.get_current_dir()
        if oil_dir then
            dir = oil_dir:gsub("^oil://", "")
        end
    end
    -- Ensure trailing slash
    dir = dir:gsub("/+$", "") .. "/"

    -- nvim_input simulates raw user keystrokes
    -- <C-u> clears any existing range/garbage in cmdline
    vim.api.nvim_input(":e " .. dir)
end

vim.keymap.set({ "n", "i" }, "<C-x><C-f>", "<cmd>lua _G.emacs_find_file()<CR>", { silent = true })
vim.keymap.set({ "n", "i" }, "<C-x><Right>", "<cmd>lua _G.emacs_find_file()<CR>", { silent = true })

vim.keymap.set({ "i" }, "<C-x>b", "<C-o>:buffer ", { silent = false })
vim.keymap.set({ "n" }, "<C-x>b", ":buffer ", { silent = false })

--- Window management similar to emacs
local modes = { "n", "i", "v" }

for _, mode in ipairs(modes) do
  local cmd_prefix = (mode == "i") and "<C-o>" or ""

  -- C-x 0: Close current window
  vim.keymap.set(mode, "<C-x>0", cmd_prefix .. "<C-w>c", { desc = "Close window" })

  -- C-x 1: Close all other windows (Only)
  vim.keymap.set(mode, "<C-x>1", cmd_prefix .. "<C-w>o", { desc = "Only window" })

  -- C-x 2: Split horizontal
  vim.keymap.set(mode, "<C-x>2", cmd_prefix .. "<C-w>s", { desc = "Split horizontal" })

  -- C-x 3: Split vertical
  vim.keymap.set(mode, "<C-x>3", cmd_prefix .. "<C-w>v", { desc = "Split vertical" })

  -- C-x o: Jump to other window
  vim.keymap.set(mode, "<C-x>o", cmd_prefix .. "<C-w>w", { desc = "Other window" })
end





-- M-! : Run + Show (Echo area)
vim.keymap.set({ "n", "i" }, "<M-!>", function()
  vim.ui.input({ prompt = "Shell command: " }, function(cmd)
    if cmd and cmd ~= "" then
      local out = vim.fn.system(cmd)
      print(out)
    end
  end)
end, { desc = "Shell command (show)" })

-- M-u M-! : Run + Insert (Emacs C-u M-! style)
vim.keymap.set({ "n", "i" }, "<M-u><M-!>", function()
  vim.ui.input({ prompt = "Shell command (insert): " }, function(cmd)
    if cmd and cmd ~= "" then
      local out = vim.fn.systemlist(cmd)
      vim.api.nvim_put(out, "c", true, true)
    end
  end)
end, { desc = "Shell command (insert)" })

-- M-x in insert: enter command mode
vim.keymap.set("i", "<M-x>", "<C-o>:", { desc = "Emacs M-x" })
-- M-x in normal: enter command mode
vim.keymap.set("n", "<M-x>", ":", { desc = "Emacs M-x" })









-- mimic C-t in emacs

-- mimic C-t in emacs
-- Swap 1 char
vim.keymap.set("i", "<C-t>", "<Esc>xpa", { desc = "Transpose chars" })
vim.keymap.set("n", "<C-t>", "xp", { desc = "Transpose chars" })

-- mimic A-m in emacs
-- Move to indentation
vim.keymap.set("n", "<M-m>", "^", { desc = "Back to indentation" })
vim.keymap.set("i", "<M-m>", "<C-o>^", { desc = "Back to indentation" })

--- requries mini-operators.nvim
--- This is an attempt to make a less scuffed M-t emacs.

-- need this for M-t
-- Define better `b` that actuall goes to the previous word and skips whitespace. But put it on a fake key:
vim.keymap.set('n', '<Plug>(smart-b)', [[col('.') == 1 || col('.') == match(getline('.'), '\S') + 1 ? "?\\S\r" : "b"]], { expr = true })

-- TODO:
-- It still not the best I would love to make it a 1 to 1 match where it is smart to skip dots and -- and such. but later.
-- mimic M-t In emacs
-- Swap 2 words
vim.keymap.set("i", "<M-t>", function()
  local col = vim.fn.col('.')
  local line = vim.api.nvim_get_current_line()
  local first_char_col = vim.fn.match(line, [[\S]]) + 1

  local keys = "<Esc><Right>bgsiwwgsiwea"

  if col == 1 then
    keys = "<Esc><Plug>(smart-b)gsiweegsiwe<Plug>(smart-b)<Plug>(smart-b)a"    -- Start of line: swap first two
  elseif col > #line then
    keys = "<Esc>bgsiweegsiwea"    -- End of line: swap last two
  elseif col <= first_char_col then
    keys = "<Esc>wbgsiwwgsiwea"    -- Before first word: swap first two
  end

  return keys
end, { expr = true, remap = true })


vim.keymap.set("n", "<M-t>", function()
  local col = vim.fn.col('.')
  local line = vim.api.nvim_get_current_line()
  local first_char_col = vim.fn.match(line, [[\S]]) + 1

  local keys = "<Esc>bgsiweegsiwe"

  if col == 1 then
    keys = "<Esc><Plug>(smart-b)gsiweegsiwe<Plug>(smart-b)<Plug>(smart-b)"    -- Start of line: swap first two
  elseif col > #line then
    keys = "<Esc>bgsiweegsiwe"    -- End of line: swap last two
  elseif col <= first_char_col then
    keys = "<Esc>wbgsiweegsiwe"    -- Before first word: swap first two
  end

  return keys
end, { expr = true, remap = true })

-- mimic C-down left up right in emacs
vim.keymap.set("i", "<C-Down>", "<C-o>}", { desc = "Jump paragraph down" })
vim.keymap.set("i", "<C-Up>",   "<C-o>{", { desc = "Jump paragraph up" })
vim.keymap.set("n", "<C-Down>", "}",       { desc = "Jump paragraph down" })
vim.keymap.set("n", "<C-Up>",   "{",       { desc = "Jump paragraph up" })


-- -------------------------------------------------------------
-- Smart zz (Emacs C-l style: center → top → bottom)
-- -------------------------------------------------------------
-- -------------------------------------------------------------
-- Smart recenter (Emacs C-l: center → top → bottom)
-- Shared fn so both zz and insert-mode C-l use same state
-- -------------------------------------------------------------
local last_pos  = { 0, 0 }
local zz_state  = 0

local function smart_recenter()
  local curr_pos = vim.api.nvim_win_get_cursor(0)
  if curr_pos[1] ~= last_pos[1] or curr_pos[2] ~= last_pos[2] then
    zz_state = 0
  end
  local old_scrolloff = vim.opt.scrolloff:get()
  vim.opt.scrolloff = 0
  if zz_state == 0 then
    vim.cmd("normal! zz")
    zz_state = 1
  elseif zz_state == 1 then
    vim.cmd("normal! zt")
    zz_state = 2
  else
    vim.cmd("normal! zb")
    zz_state = 0
  end
  vim.opt.scrolloff = old_scrolloff
  last_pos = curr_pos
end

vim.keymap.set("n", "zz",    smart_recenter, { desc = "Smart zz: center → top → bottom" })
vim.keymap.set("i", "<C-l>", smart_recenter, { desc = "Recenter (Emacs C-l)" })



-- -------------------------------------------------------------
-- Basic Movement (Insert)
-- -------------------------------------------------------------
-- NOTE: C-n/C-p shadow nvim-cmp completion nav.
-- If using a completion plugin, either remove these two or remap
-- completion to <Down>/<Up>.
vim.keymap.set("i", "<C-f>", "<Right>", { desc = "Forward char" })
vim.keymap.set("i", "<C-b>", "<Left>",  { desc = "Backward char" })
vim.keymap.set("i", "<C-n>", "<Down>",  { desc = "Next line" })
vim.keymap.set("i", "<C-p>", "<Up>",    { desc = "Previous line" })
vim.keymap.set("i", "<C-a>", "<Home>",  { desc = "Beginning of line" })
vim.keymap.set("i", "<C-e>", "<End>",   { desc = "End of line" })

-- M-f/b: word forward/backward
-- FIX: was <C-o>w (start of next word). M-f in Emacs → end of word → use e
vim.keymap.set("i", "<M-f>", "<C-o>e", { desc = "Forward word" })
vim.keymap.set("i", "<M-b>", "<C-o>b", { desc = "Backward word" })

-- keep this
vim.keymap.set("n", "<C-Right>", "w",   { desc = "End of line" })
vim.keymap.set("n", "<C-left>", "b",   { desc = "End of line" })

-- I have keyd so this is Capslock-f and A-
-- keep this
vim.keymap.set("i", "<C-Right>", "<C-o>e", { desc = "Forward word" })
vim.keymap.set("i", "<M-Left>", "<C-o>b", { desc = "Backward word" })

-- -------------------------------------------------------------
-- Deletion (Insert)
-- -------------------------------------------------------------
vim.keymap.set("i", "<C-d>",  "<Del>",        { desc = "Delete char forward" })

-- This is not smart... if there is nothing to kill in line it should kill the line itself
-- vim.keymap.set("i", "<C-k>",  '<C-o>"+D',     { desc = "Kill line (to clipboard)" })

-- vim.keymap.set("i", "<C-k>", function()
--   local col = vim.fn.col(".")
--   local line = vim.fn.getline(".")
--
--   if col > #line then
--     -- At end of line: delete newline (join)
--     return vim.api.nvim_replace_termcodes("<Del>", true, true, true)
--   else
--     -- Not at end: kill to end of line
--     return vim.api.nvim_replace_termcodes('<C-o>"+D', true, true, true)
--   end
-- end, { expr = true, desc = "Kill line or join" })

vim.keymap.set("i", "<M-d>",  "<C-o>dw",      { desc = "Kill word forward" })
vim.keymap.set("i", "<M-BS>", "<C-w>",        { desc = "Kill word backward" })




-- -------------------------------------------------------------
-- Selection & Mark
-- -------------------------------------------------------------
vim.keymap.set("i", "<C-Space>", "<C-o>v", { desc = "Set mark (start selection)" })

-- Exchange point and mark (flip cursor in visual selection)
vim.keymap.set("v", "<C-x><C-x>", "o", { desc = "Exchange point and mark" })

-- FIX: was v_ (first non-blank of line, wrong). viw = select word under cursor.
vim.keymap.set("i", "<M-@>", "<C-o>viw", { desc = "Mark word" })
vim.keymap.set("i", "<M-2>", "<C-o>viw", { desc = "Mark word (terminal fallback for M-@)" })

-- FIX: was v} (only forward). Now selects whole paragraph: jump to start, then select to end.
vim.keymap.set("i", "<M-h>", "<C-o>{<C-o>v}", { desc = "Mark paragraph" })

-- -------------------------------------------------------------
-- Search
-- -------------------------------------------------------------
vim.keymap.set("i", "<C-s>", "<C-o>/", { desc = "Search forward" })
vim.keymap.set("i", "<C-r>", "<C-o>?", { desc = "Search backward" })

-- -------------------------------------------------------------
-- Visual Mode Movement (keeps selection active)
-- -------------------------------------------------------------
vim.keymap.set("v", "<C-f>", "l", { desc = "Forward char" })
vim.keymap.set("v", "<C-b>", "h", { desc = "Backward char" })
vim.keymap.set("v", "<C-n>", "j", { desc = "Next line" })
vim.keymap.set("v", "<C-p>", "k", { desc = "Previous line" })
vim.keymap.set("v", "<C-a>", "0", { desc = "Beginning of line" })
vim.keymap.set("v", "<C-e>", "$", { desc = "End of line" })

-- FIX: was w (start of next word). Emacs M-f → end of word.
vim.keymap.set("v", "<M-f>", "e", { desc = "Forward word" })
vim.keymap.set("v", "<M-b>", "b", { desc = "Backward word" })

-- -------------------------------------------------------------
-- Quit / Kill / Copy (Visual)
-- -------------------------------------------------------------
-- C-g: cancel selection, return to Insert
-- (Emacs C-g = cancel; returning to Insert fits an insert-centric workflow)
vim.keymap.set("v", "<C-g>",  "<Esc>i",  { desc = "Cancel selection, back to Insert" })
vim.keymap.set("v", "<C-w>",  '"+d',     { desc = "Kill region (cut to clipboard)" })
vim.keymap.set("v", "<M-w>",  '"+y',     { desc = "Copy region (to clipboard)" })

-- Yank (paste from clipboard) in Insert
vim.keymap.set("i", "<C-y>", "<C-r>+", { desc = "Yank (paste from clipboard)" })


vim.keymap.set("i", "<C-h>", "<C-w>", { desc = "Delete word backward" })
-- If C-BackSpace sends a distinct keycode, keep this.
-- But your 'cat -v' shows it sends ^H, so this map is likely redundant.ok
-- vim.keymap.set("i", "<C-BackSpace>", "<C-w>", { desc = "Delete word backward" })



-- -------------------------------------------------------------
-- Buffer & File (C-x prefix)
-- -------------------------------------------------------------
vim.keymap.set("i", "<C-x>k",     "<C-o>:bd ",    { desc = "Kill buffer" })
vim.keymap.set("n", "<C-x>k",     ":bd ",    { desc = "Kill buffer" })
vim.keymap.set("i", "<C-x><C-s>", "<C-o>:w<CR>",     { desc = "Save file" })
vim.keymap.set("n", "<C-x><C-s>", ":w<CR>",     { desc = "Save file" })

-- FIX: was <C-o>gg<C-o>vG (double C-o, fragile).
-- Leaves insert, selects all in visual-line mode. Select-all implies leaving insert anyway.
vim.keymap.set("i", "<C-x>h", "<Esc>ggVG", { desc = "Mark whole buffer (select all)" })
vim.keymap.set("n", "<C-x>h", "ggVG", { desc = "Mark whole buffer (select all)" })



---- Ok this scruffed thing actually kinda works but meh but it's fine as a started maybe idk

-- local emacs_mark = nil  -- FIX: declare local
--
-- -- C-Space / NUL: Set Mark
-- local function set_mark()
--   emacs_mark = vim.api.nvim_win_get_cursor(0)
--   print("Mark set")
-- end
-- vim.keymap.set({ "n", "i" }, "<C-Space>", set_mark, { desc = "Set Emacs mark" })
-- vim.keymap.set({ "n", "i" }, "<NUL>",     set_mark, { desc = "Set Emacs mark" })  -- FIX: terminal compat
--
-- -- C-g: Quit / Clear Mark
-- vim.keymap.set({ "n", "i" }, "<C-g>", function()
--   if emacs_mark then  -- FIX: only fire when mark exists
--     emacs_mark = nil
--     print("Mark cleared")
--   end
--   return "<Esc>"
-- end, { expr = true })
--
-- -- M-w: Copy Region
-- vim.keymap.set("i", "<M-w>", function()
--   if not emacs_mark then return end
--   local cur = vim.api.nvim_win_get_cursor(0)
--   local s_row, s_col = emacs_mark[1], emacs_mark[2]
--   local e_row, e_col = cur[1], cur[2]
--   if s_row > e_row or (s_row == e_row and s_col > e_col) then
--     s_row, s_col, e_row, e_col = e_row, e_col, s_row, s_col
--   end
--   local lines = vim.api.nvim_buf_get_text(0, s_row - 1, s_col, e_row - 1, e_col, {})
--   vim.fn.setreg("+", table.concat(lines, "\n"))
--   print("Region copied")
--   emacs_mark = nil
-- end)
--
-- -- C-w: Kill Region
-- vim.keymap.set("i", "<C-w>", function()
--   if not emacs_mark then
--     -- FIX: proper word-backward delete via reverse-string pattern
--     local row, col = unpack(vim.api.nvim_win_get_cursor(0))
--     if col == 0 then return end
--     local before = vim.api.nvim_get_current_line():sub(1, col)
--     local new_col = #(before:reverse():gsub("^%s*%S+", "", 1):reverse())
--     vim.api.nvim_buf_set_text(0, row - 1, new_col, row - 1, col, {})
--     vim.api.nvim_win_set_cursor(0, { row, new_col })
--     return
--   end
--   local cur = vim.api.nvim_win_get_cursor(0)
--   local s_row, s_col = emacs_mark[1], emacs_mark[2]
--   local e_row, e_col = cur[1], cur[2]
--   if s_row > e_row or (s_row == e_row and s_col > e_col) then
--     s_row, s_col, e_row, e_col = e_row, e_col, s_row, s_col
--   end
--   vim.api.nvim_buf_set_text(0, s_row - 1, s_col, e_row - 1, e_col, {})
--   vim.api.nvim_win_set_cursor(0, { s_row, s_col })  -- FIX: reposition cursor
--   emacs_mark = nil
-- end)
--
-- -- C-x o: Jump window (FIX: no loop, no dead prefix var)
-- vim.keymap.set({ "n", "i", "v" }, "<C-x>o", function()
--   vim.cmd("stopinsert")
--   vim.cmd("wincmd w")
-- end)


local ns = vim.api.nvim_create_namespace("emacs_mark")
local emacs_mark = nil

local function clear_mark()
  emacs_mark = nil
  vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
end

local function update_hl()
  if not emacs_mark then return end
  local cur = vim.api.nvim_win_get_cursor(0)
  local m = emacs_mark
  local r1, c1, r2, c2 = m[1]-1, m[2], cur[1]-1, cur[2]
  if r1 > r2 or (r1 == r2 and c1 > c2) then
    r1, c1, r2, c2 = r2, c2, r1, c1
  end
  vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
  vim.api.nvim_buf_set_extmark(0, ns, r1, c1, { end_row = r2, end_col = c2, hl_group = "Visual" })
end

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, { callback = update_hl })

-- C-Space: Set Mark
local function set_mark()
  emacs_mark = vim.api.nvim_win_get_cursor(0)
  update_hl()
  print("Mark set")
end

vim.keymap.set("i", "<C-Space>", set_mark)
vim.keymap.set("i", "<NUL>",     set_mark)
vim.keymap.set("n", "<C-Space>", "v", { remap = true }) -- Normal mode parity

-- C-g: Quit
vim.keymap.set({ "n", "i" }, "<C-g>", function()
  if emacs_mark then clear_mark(); print("Mark cleared"); return "<Ignore>" end
  return "<Esc>"
end, { expr = true })

-- Update helper to return 4 nils for LSP clarity
local function get_region()
  if not emacs_mark then return nil, nil, nil, nil end
  local cur = vim.api.nvim_win_get_cursor(0)
  local s, e = emacs_mark, cur
  if s[1] > e[1] or (s[1] == e[1] and s[2] > e[2]) then s, e = e, s end
  return s[1]-1, s[2], e[1]-1, e[2]
end

-- M-w: Copy Region
vim.keymap.set("i", "<M-w>", function()
  local r1, c1, r2, c2 = get_region()
  -- Check all four to satisfy LSP integer requirement
  if r1 and c1 and r2 and c2 then
    local lines = vim.api.nvim_buf_get_text(0, r1, c1, r2, c2, {})
    vim.fn.setreg("+", table.concat(lines, "\n"))
    clear_mark()
    print("Region copied")
  end
end)

-- C-w: Kill Region
vim.keymap.set("i", "<C-w>", function()
  local r1, c1, r2, c2 = get_region()
  if r1 and c1 and r2 and c2 then
    vim.api.nvim_buf_set_text(0, r1, c1, r2, c2, {})
    vim.api.nvim_win_set_cursor(0, { r1 + 1, c1 })
    clear_mark()
  else
    -- Word-backward logic (fallback when no mark)
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    if col == 0 then return end
    local line = vim.api.nvim_get_current_line():sub(1, col)
    local new_col = #(line:reverse():gsub("^%s*%S+", "", 1):reverse())
    vim.api.nvim_buf_set_text(0, row-1, new_col, row-1, col, {})
    vim.api.nvim_win_set_cursor(0, { row, new_col })
  end
end)


-- C-x o: Jump
-- vim.keymap.set({ "n", "i", "v" }, "<C-x>o", function()
--   vim.cmd("wincmd w")
--   if vim.api.nvim_get_mode().mode == 'n' then vim.cmd("startinsert") end
-- end)







--# why not ? I don't need c-y I have capslock and shit lol
vim.keymap.set("n", "<C-i>", "<C-i>zz")
vim.keymap.set("n", "<C-o>", "<C-o>zz")

vim.keymap.set("n", "<A-s>", "<C-i>zz")
vim.keymap.set("n", "<A-d>", "<C-o>zz")

vim.keymap.set("n", "<A-i>", "ma=ap'a")

--#Oh this how he restarts the Lsp Ah I see
vim.keymap.set("n", "<leader>zig", "<cmd>lsp restart<cr>")

--# Mr.Prime has this <leader>vwm but it require("vim-with-me") and I don't know what's this? and
--# I don't care tbh maybe it's a twitch things ? gotta maybe watch old vids or twitch live stream to know tbh I don't care

-- greatest remap ever
--# btw Side note after using it it works fine and it's nice... just make sure to like visually select first
--# the visual select is not mandatory but it makes it nicer
--##update(W38 Wed, 17 at 06:53): The issue was because I had <leader>pv and when I hit <leader>p it waits a bit and that screws it off with the alignment.
--##update a solution would be to just hit <leader>P yes it works even though it's <leader>p. or just make A-p easy man.
--##update idk maybe I'm wrong and deleting anything related to pv pf .... ect will keep the problem persistent idk man
-- vim.keymap.set("x", "<leader>p", [["_dP]])

--# why Alt+p beause <leader>p I have to wait because of idk why. and it's funky it adds <space> for no reason
--##btw(W38 Wed, 17 at 06:59) if you are thinking about making it like p & P just forget it it does't work. just go up or left with j or k and
--##btw just A-p... this is already good enough I think.
-- vim.keymap.set("x", "A-p", [["_dP]])
-- vim.keymap.set("x", "<leader>p.", "\"_dP")
vim.keymap.set("x", "<leader>p", '"_dP')
-- vim.keymap.set("x", "<leader>p;", "\"_dP")
--# why Alt+p beause <leader>p I have to wait because of idk why. and it's funky it adds <space> for no reason
--##btw(W38 Wed, 17 at 06:59) if you are thinking about making it like p & P just forget it it does't work. just go up or left with j or k and
--##btw just A-p... this is already good enough I think.
-- vim.keymap.set("x", "A-p", [["_dP]])

vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

-- This is going to get me cancelled
--# This is an old thing I guess... to be honest they probably fixed this right?
--# I could remove it... this will make me one like place to do things
vim.keymap.set("i", "<C-c>", "<Esc>")

--#idk why this is this
vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<A-Q>", ":tabclose<CR>", { silent = true, desc = "Close current tab" })

-- Move current tab to the left
vim.keymap.set("n", "<A-C-h>", ":tabmove -1<CR>", { silent = true, desc = "Move tab left" })

-- Move current tab to the right
vim.keymap.set("n", "<A-C-l>", ":tabmove +1<CR>", { silent = true, desc = "Move tab right" })

--- !I already have <leader>ttt and <leader>ggg also there is like fugitive learn it so you don't have to do lazygit <leader>ggg
-- vim.keymap.set("n", "<C-t>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- vim.keymap.set("n", "<A-h>", "<cmd>silent !tmux-sessionizer -s 0 --vsplit<CR>")
-- vim.keymap.set("n", "<A-y>", "<cmd>silent !tmux neww tmux-sessionizer -s 4 <CR>")
-- vim.keymap.set("n", "<A-h>", "<cmd>silent !tmux neww tmux-sessionizer -s 0<CR>")
-- vim.keymap.set("n", "<A-l>", "<cmd>silent !tmux-sessionizer -s 1 --vsplit<CR>")
-- vim.keymap.set("n", "<A-L>", "<cmd>silent !tmux neww tmux-sessionizer -s 1<CR>")

-- # This is how I deal with the stupid comments... do not make this <leader>o and <leader>O
-- # why? because it will lag. and vim-unhinged [<Space> and ]<Scape> are useful but not what I want
-- because they keep you in normal mode and also they make a new line like actual new line which is good
-- but I just want a line bellow the comment or above the comment that is not commented that's all, but
-- also have the advantage of autocommenting. So gotta sacrifice A-o and A-O


------ I can't do C-o that would brick nvim and C-o in nvim the concept of jumps is so nice So we use M-o and M-S-o
-- Below
vim.keymap.set("n", "<A-o>", "o<Esc>S", { desc = "Open new blank line below" })
vim.keymap.set("i", "<A-O>", "<C-o>o<Esc>S", { desc = "Open new blank line below" })

-- Above

vim.keymap.set("n", "<A-O>", "O<Esc>S", { desc = "Open new blank line above" })
vim.keymap.set("i", "<A-o>", "<C-o>O<Esc>S", { desc = "Open new blank line above" })









-- Remap Ctrl+f to scroll up
-- vim.keymap.set("n", "<C-f>", "<C-f>zz")
-- vim.keymap.set("n", "<C-g>", "<C-u>zz")
-- vim.keymap.set("v", "<C-f>", "<C-f>zz")
-- vim.keymap.set("v", "<C-g>", "<C-u>zz")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<PageUp>", "<C-u>zz")
vim.keymap.set("n", "<PageDown>", "<C-d>zz")

vim.keymap.set("v", "<PageUp>", "<C-u>zz")
vim.keymap.set("v", "<PageDown>", "<C-d>zz")


-- vim.keymap.set("n", "<A-f>", "<C-d>zz")
-- vim.keymap.set("v", "<A-f>", "<C-d>zz")

-- Remap Ctrl+b to scroll down
-- I don't use C-b and C-f just make everything C-u C-d or use defaults man
-- vim.keymap.set("n", "<C-b>", "<C-b>zz")
-- vim.keymap.set("n", "<A-b>", "<C-u>zz")
-- vim.keymap.set("v", "<A-b>", "<C-u>zz")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Open the Quickfix List (Compiler/Search errors)
vim.keymap.set("n", "<leader>q", "<cmd>copen<CR>", { desc = "Open Quickfix List" })

-- Open the Location List (LSP Diagnostics/local errors)
vim.keymap.set("n", "<leader>Q", "<cmd>lopen<CR>", { desc = "Open Location List" })

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

--# I don't know what this is for and I don't use it idk gotta see what is this for
-- vim.keymap.set(
--     "n",
--     "<leader>ee",
--     "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
-- )

--# same with this I don't use it and I don't git it
-- vim.keymap.set(
--     "n",
--     "<leader>ea",
--     "oassert.NoError(err, \"\")<Esc>F\";a"
-- )

--# same with this I don't use it and I don't get it
-- vim.keymap.set(
--     "n",
--     "<leader>el",
--     "oif err != nil {<CR>}<Esc>O.logger.Error(\"error\", \"error\", err)<Esc>F.;i"
-- )

--# Same with these two I don't use them and I don't get them... and :so thing typing I get it
--# it's a bit frustrating not gonnna lie
-- vim.keymap.set("n", "<leader>ca", function()
--     require("cellular-automaton").start_animation("make_it_rain")
-- end)
--
-- vim.keymap.set("n", "<leader><leader>", function()
--     vim.cmd("so")
-- end)

-- ---- these are mine ---

--- This is stupid use redline this sucks btw
-- In Insert Mode, map <C-k> to delete to the end of the line
-- vim.keymap.set("i", "<C-k>", "<C-o>d$", {
-- 	noremap = true,
-- 	silent = true,
-- 	desc = "Delete from cursor to end of line",
-- })

-- END---- these are mind END-----

-- vim.keymap.set(
--     "n",
--     "<leader>ee",
--     "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
-- )

-- vim.keymap.set("n", "<leader><leader>", function()
--    vim.cmd("so")
-- end)

--# I think I prefer it with <leader>S because I think <leader><leader> will screw things i'm not sure
-- vim.keymap.set("n", "<leader>S", function()
--    vim.cmd("so")
-- end)

-- Faster window navigation
-- This is whatever just use C-w C-h
-- vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window", remap = true })
-- vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to lower window", remap = true })
-- vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper window", remap = true })
-- vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window", remap = true })

-- vim.keymap.set('n', '<C-.>', '<C-w>>', { desc = 'Move to right window', remap = true })
-- vim.keymap.set('n', '<C-,>', '<C-w><', { desc = 'Move to right window', remap = true })

-- yeah this fixes it on termux just freaking have this right... and btw hoold space for numbers and it works out lok
vim.keymap.set("n", "<leader>.", "5<C-w>>", { desc = "Move to right window", remap = true })
vim.keymap.set("n", "<leader>,", "5<C-w><", { desc = "Move to right window", remap = true })

vim.keymap.set("n", "<A-.>", "5<C-w>>", { desc = "Move to right window", remap = true })
vim.keymap.set("n", "<A-,>", "5<C-w><", { desc = "Move to right window", remap = true })

vim.keymap.set("n", "<leader>=", "5<C-w>+", { desc = "Increase window height by 5" })
vim.keymap.set("n", "<leader>-", "5<C-w>-", { desc = "Decrease window height by 5" })
vim.keymap.set("n", "<A-=>", "5<C-w>+", { desc = "Increase window height by 5" })
vim.keymap.set("n", "<A-->", "5<C-w>-", { desc = "Decrease window height by 5" })
vim.keymap.set("n", "<leader>+", "<Cmd>wincmd =<CR>", { desc = "Decrease window height by 5" })

-- QoL movements (don't use alt+hjkl in tmux)
vim.keymap.set("n", "<A-l>", "20zl", { desc = "I don't want to hit shift " })
vim.keymap.set("n", "<A-h>", "20zh", { desc = "I don't want to hit shift" })
-- vim.keymap.set("n", "<A-S-j>", "<c-e>", { desc = "I don't want to hit shift" })
-- vim.keymap.set("n", "<A-S-k>", "<c-y>", { desc = "I don't want to hit shift" })
vim.keymap.set("n", "<A-S-l>", "zl", { desc = "I don't want to hit shift " })
vim.keymap.set("n", "<A-S-h>", "zh", { desc = "I don't want to hit shift" })

-- Old shit that I never use because I just use like 'home' and 'end' they work
-- in insert mode too lol. So like why even use this lol. and for M I just hit 0
-- man no big deal.
-- vim.keymap.set("n", "H", "0", { desc = "I don't want to hit shift" })
-- vim.keymap.set("n", "L", "$", { desc = "I don't want to hit shift" })
-- vim.keymap.set("n", "M", "0", { desc = "I don't want to hit shift" })

-- Cycle through tabs
vim.keymap.set("n", "<S-l>", "gt", { desc = "Next tab" })
vim.keymap.set("n", "<S-h>", "gT", { desc = "Previous tab" })

vim.keymap.set("n", "M", ":tab split<CR>", { silent = true, desc = "Zoom window" })


-- THIS IS NICE: But I never really use it I like the idea of harpoon better. So if I had tabs I move to the mmanually ok?
-- Tab Navigation (Moved to Function Keys)
-- for i = 1, 9 do
-- 	vim.keymap.set("n", "<leader><F" .. i .. ">", i .. "gt", { desc = "Tab " .. i })
-- end






-- Manual tab switching
-- vim.keymap.set("n", "<leader>1", "1gt", { desc = "Tab 1" })
-- vim.keymap.set("n", "<leader>+", "1gt", { desc = "Tab 1" })
-- vim.keymap.set("n", "<leader>2", "2gt", { desc = "Tab 2" })
-- vim.keymap.set("n", "<leader>[", "2gt", { desc = "Tab 2" })
-- vim.keymap.set("n", "<leader>3", "3gt", { desc = "Tab 3" })
-- vim.keymap.set("n", "<leader>{", "3gt", { desc = "Tab 3" })
-- vim.keymap.set("n", "<leader>4", "4gt", { desc = "Tab 4" })
-- vim.keymap.set("n", "<leader>(", "4gt", { desc = "Tab 4" })
-- vim.keymap.set("n", "<leader>5", "5gt", { desc = "Tab 5" })
-- vim.keymap.set("n", "<leader>&", "5gt", { desc = "Tab 5" })
-- vim.keymap.set("n", "<leader>6", "6gt", { desc = "Tab 6" })
-- vim.keymap.set("n", "<leader>=", "6gt", { desc = "Tab 6" })
-- vim.keymap.set("n", "<leader>7", "7gt", { desc = "Tab 7" })
-- vim.keymap.set("n", "<leader>)", "7gt", { desc = "Tab 7" })
-- vim.keymap.set("n", "<leader>8", "8gt", { desc = "Tab 8" })
-- vim.keymap.set("n", "<leader>}", "8gt", { desc = "Tab 8" })
-- vim.keymap.set("n", "<leader>9", "9gt", { desc = "Tab 9" })
-- vim.keymap.set("n", "<leader>]", "9gt", { desc = "Tab 9" })

vim.keymap.set("n", "H", "0", { desc = "I don't want to hit shift" })
vim.keymap.set("n", "L", "$", { desc = "I don't want to hit shift" })
vim.keymap.set("n", "M", "^", { desc = "I don't want to hit shift" })

vim.keymap.set("v", "H", "0", { desc = "I don't want to hit shift" })
vim.keymap.set("v", "L", "$", { desc = "I don't want to hit shift" })
vim.keymap.set("v", "M", "^", { desc = "I don't want to hit shift" })


-- Easier tab navigation
-- vim.keymap.set('n', '<Tab>', '<cmd>tabnext<CR>', { desc = 'Go to next tab' })
-- vim.keymap.set('n', '<S-Tab>', '<cmd>tabprevious<CR>', { desc = 'Go to previous tab' })

vim.keymap.set("n", "<leader>zh", "zH", { desc = "I don't want to hit shift" })
vim.keymap.set("n", "<leader>zl", "zL", { desc = "I don't want to hit shift " })

--# capslock + alt + hjkl
vim.keymap.set("n", "<A-right>", "20zl", { desc = "I don't want to hit shift " })
vim.keymap.set("n", "<A-left>", "20zh", { desc = "I don't want to hit shift" })
vim.keymap.set("n", "<A-down>", "<c-e>", { desc = "I don't want to hit shift" })
vim.keymap.set("n", "<A-up>", "<c-y>", { desc = "I don't want to hit shift" })

--# This thing I added and I'm not sure why... maybe when I'm in wrap mode. but does this even work
--# I'm not sure to be honest when it's off it's fine
-- vim.keymap.set("n", "gJ", "mzgJ`z")

vim.keymap.set("n", "<leader>Rls", function()
	require("luasnip.loaders.from_vscode").lazy_load()
	print("Snippets reloaded!")
end, { desc = "Reload Luasnip snippets" })

vim.keymap.set("n", "<leader>cwd", "<Cmd>cd %:h<CR>", { desc = "Decrease window height by 5" })
vim.keymap.set("n", "<leader>zd", "<cmd>FzfLua zoxide<CR>")
vim.keymap.set("n", "<leader>cb", "<cmd>cd -<CR>")


-- just screwing with this I don't like `X` it makes me hit shift+x and I do mainly use x so you know
-- trying to be consistent and in terminal backspace in normal mode actually is backspace so i'm liking it
-- In your init.lua

-- =======I don't kike this it's prone to errors... maybe in the temrinal sure. ==========
-- Make Backspace delete the character to the left in Normal mode
-- vim.keymap.set('n', '<BS>', 'X', { noremap = true, silent = true })

-- idk for some reason when it's in remap.lua it's not loading well so I'll put it in here
-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- ==============================================================================
-- ==                      Smart Word Wrap Motions                           ==
-- ==============================================================================

vim.keymap.set({ "n", "v" }, "j", function()
	return vim.opt.wrap:get() and "gj" or "j"
end, { expr = true, silent = true, desc = "Smart j motion" })

vim.keymap.set({ "n", "v" }, "k", function()
	return vim.opt.wrap:get() and "gk" or "k"
end, { expr = true, silent = true, desc = "Smart k motion" })

vim.keymap.set({ "n", "v", "o" }, "0", function()
	return vim.opt.wrap:get() and "g0" or "0"
end, { expr = true, silent = true, desc = "Smart 0 motion" })

vim.keymap.set({ "n", "v", "o" }, "^", function()
	return vim.opt.wrap:get() and "g^" or "^"
end, { expr = true, silent = true, desc = "Smart ^ motion" })

vim.keymap.set({ "n", "v", "o" }, "$", function()
	return vim.opt.wrap:get() and "g$" or "$"
end, { expr = true, silent = true, desc = "Smart $ motion" })

-- vim.keymap.set("n", "<leader>sh", "<cmd>:sp<cr>", { desc = "Open Quickfix List" })
-- vim.keymap.set("n", "<leader>sv", "<cmd>:vsp<cr>", { desc = "Open Quickfix List" })
-- vim.keymap.set('n', ']q', '<cmd>cnext<cr>', { desc = "Next Quickfix Item" })
-- vim.keymap.set('n', '[q', '<cmd>cprev<cr>', { desc = "Previous Quickfix Item" })

---# Terminal like in nvim

-- Map Ctrl+f to move the cursor forward (right) in Insert Mode
-- vim.keymap.set("i", "<C-f>", "<Right>")

-- Map Ctrl+b to move the cursor backward (left) in Insert Mode
-- vim.keymap.set("i", "<C-b>", "<Left>")


-- Simulate temrinal C-a and C-e to go to end of line and beginning of line in insert mode.
vim.keymap.set("i", "<C-a>", "<C-o>0")
vim.keymap.set("i", "<C-e>", "<End>")

-- vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { silent = true })
-- vim.keymap.set("n", "<leader>Q", "<cmd>q!<CR>", { silent = true })

-- Why even have this just :w and enter manually mate I'm too used to this anyway lol
-- vim.keymap.set("n", "<leader>w", "<cmd>:w<CR>")

vim.keymap.set("n", "<Home>", "^", { desc = "Go to first line" })
vim.keymap.set("n", "<End>", "$", { desc = "Go to first line" })

vim.keymap.set("i", "<Home>", "<C-o>^", { desc = "Go to beginning of line" })
vim.keymap.set("i", "<End>", "<C-o>$", { desc = "Go to end of line" })

-- and you know nvim is annoying to yeah a man has to do what he has to do
-- Yes yes... sadly my terminal is C-S-v to past and you know my .zshrc is C-V for zi-vi-mode (gotta get that xclip)
-- WHich is use ai lol

-- -- Remaps <C-v> to paste directly at the cursor.
-- vim.keymap.set('i', '<C-v>', '<C-r>+', { desc = "Paste from system clipboard" })
-- -- Moves the original "literal insert" command to <C-q>.
-- vim.keymap.set('i',  <C-q>', '<C-v>', { desc = "Literal Insert (Original <C-v>)" })
--
--
-- -- 2. PASTE in NORMAL MODE
-- -- Remaps <C-v> to paste after the cursor.
-- vim.keymap.set('n', '<C-v>', '"+p', { desc = "Paste from system clipboard" })
-- -- Moves the original "Visual Block" command to <C-q>.
-- vim.keymap.set('n', '<C-q>', '<C-v>', { desc = "Visual Block Mode (Original <C-v>)" })
--
--
-- -- 3. PASTE in VISUAL MODE
-- -- Remaps <C-v> to paste over the selected text.
-- vim.keymap.set('v', '<C-v>', '"+p', { desc = "Paste over selection from system clipboard" })

vim.keymap.set("n", "<leader>wp", function()
	if vim.opt.wrap:get() then
		vim.opt.wrap = false
	else
		vim.opt.wrap = true
	end
end, { desc = "Toggle word wrap" })

vim.keymap.set("n", "<leader>wr", function()
	if vim.opt.relativenumber:get() then
		vim.opt.relativenumber = false
	else
		vim.opt.relativenumber = true
	end
end, { desc = "Toggle relative line numbers" })

vim.keymap.set("n", "<leader>wn", function()
	if vim.opt.number:get() then
		vim.opt.number = false
	else
		vim.opt.number = true
	end
end, { desc = "Toggle absolute line numbers" })

-- This is for keyd my capslock setup

-- Normal mode: Delete to the end of the word
vim.keymap.set("n", "<C-Delete>", "dw", { noremap = true, silent = true })

-- Insert mode: Delete to the end of the word and stay in insert mode
vim.keymap.set("i", "<C-Delete>", "<C-o>dw", { noremap = true, silent = true })

-- This helps me for the i3 thing where I changed the default position of the split.
-- I mainly changed the position of the spit so that I can do things with the left hand
-- This is nice I like it
vim.keymap.set("n", "<C-w>z", "<C-w>s", { desc = "Horizontal split (replaces close preview)" })

-- Toggle between current and last accessed tab
vim.keymap.set("n", "<leader>`", function()
	local last_tab = vim.fn.tabpagenr("#")
	if last_tab > 0 then
		vim.cmd(last_tab .. "tabnext")
	else
		print("No last tab to return to!")
	end
end, { desc = "Toggle last tab" })

vim.keymap.set("n", "<leader>$", function()
	local last_tab = vim.fn.tabpagenr("#")
	if last_tab > 0 then
		vim.cmd(last_tab .. "tabnext")
	else
		print("No last tab to return to!")
	end
end, { desc = "Toggle last tab" })

-- This is just some quality of life so that the K thing the hover pop up thing
-- makes it like escape can escape it without moving my cursor.
-- vim.keymap.set('n', '<Esc>', function()
--     -- Close all floating windows
--     for _, win in ipairs(vim.api.nvim_list_wins()) do
--         if vim.api.nvim_win_get_config(win).relative ~= "" then
--             vim.api.nvim_win_close(win, false)
--         end
--     end
--     -- Clear search highlights (optional, but recommended for Esc)
--     vim.cmd("nohlsearch")
-- end, { desc = "Close floating windows and clear search" })

vim.keymap.set("n", "<Esc>", function()
	-- 1. Clear search highlights
	vim.cmd("nohlsearch")
	-- 2. Get the current window ID so we don't accidentally close it
	local current_win = vim.api.nvim_get_current_win()
	-- 3. Only kill "Focusable" floating windows that are NOT the current window
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_is_valid(win) and win ~= current_win then
			local config = vim.api.nvim_win_get_config(win)
			if config.relative ~= "" and config.focusable then
				vim.api.nvim_win_close(win, false)
			end
		end
	end
end, { desc = "Clean Escape: Kill hovers and clear highlights" })
