-- Map Space to do nothing
vim.keymap.set('n', '<Space>', '<Nop>', { noremap = true, silent = true })

-- Map Backspace to do nothing
vim.keymap.set('n', '<BS>', '<Nop>', { noremap = true, silent = true })



vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

--# <leader>pv is in neo-tree it brings a neo-tree float. because :Ex is stupid with jumplist

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

--# i don't understand this <Plug>.... thing is this a lazynvim ? or is this in packer or what
-- vim.api.nvim_set_keymap("n", "<leader>tf", "<Plug>PlenaryTestFile", { noremap = false, silent = false })

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

--# why not ? I don't need c-y I have capslock and shit lol
vim.keymap.set("n", "<c-i>", "<C-i>zz")
vim.keymap.set("n", "<c-o>", "<C-o>zz")

vim.keymap.set("n", "<A-s>", "<C-i>zz")
vim.keymap.set("n", "<A-d>", "<C-o>zz")

vim.keymap.set("n", "<A-i>", "ma=ap'a")

--#Oh this how he restarts the Lsp Ah I see
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

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

vim.keymap.set("n", "Q", "<nop>")

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
vim.keymap.set("n", "<A-o>", "o<Esc>S", { desc = "Open new blank line below (Insert Mode)" })

vim.keymap.set("n", "<A-O>", "O<Esc>S", { desc = "Open new blank line above (Insert Mode)" })

-- Remap Ctrl+f to scroll up
-- vim.keymap.set("n", "<C-f>", "<C-f>zz")
vim.keymap.set("n", "<A-j>", "<C-d>zz")
vim.keymap.set("v", "<A-j>", "<C-d>zz")

-- Remap Ctrl+b to scroll down
-- I don't use C-b and C-f just make everything C-u C-d or use defaults man
-- vim.keymap.set("n", "<C-b>", "<C-b>zz")
vim.keymap.set("n", "<A-k>", "<C-u>zz")
vim.keymap.set("v", "<A-k>", "<C-u>zz")

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

-- In Insert Mode, map <C-k> to delete to the end of the line
vim.keymap.set("i", "<C-k>", "<C-o>d$", {
	noremap = true,
	silent = true,
	desc = "Delete from cursor to end of line",
})

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
vim.keymap.set("n", "<A-S-j>", "<c-e>", { desc = "I don't want to hit shift" })
vim.keymap.set("n", "<A-S-k>", "<c-y>", { desc = "I don't want to hit shift" })
vim.keymap.set("n", "<A-S-l>", "zl", { desc = "I don't want to hit shift " })
vim.keymap.set("n", "<A-S-h>", "zh", { desc = "I don't want to hit shift" })


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
vim.keymap.set("i", "<C-f>", "<Right>")

-- Map Ctrl+b to move the cursor backward (left) in Insert Mode
vim.keymap.set("i", "<C-b>", "<Left>")

-- Go to the first non-whitespace character of the line (like ^)
-- Not quite like C-a if I want C-a I just do the like Capslock+a
-- vim.keymap.set("i", "<C-a>", "<C-o>^")
-- Go to the end of the line (like Ctrl+e in the terminal)
-- vim.keymap.set("i", "<C-e>", "<End>")

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


vim.keymap.set('n', '<leader>wp', function()
  if vim.opt.wrap:get() then
    vim.opt.wrap = false
  else
    vim.opt.wrap = true
  end
end, { desc = "Toggle word wrap" })

vim.keymap.set('n', '<leader>wr', function()
  if vim.opt.relativenumber:get() then
    vim.opt.relativenumber = false
  else
    vim.opt.relativenumber = true
  end
end, { desc = "Toggle relative line numbers" })


vim.keymap.set('n', '<leader>wn', function()
  if vim.opt.number:get() then
    vim.opt.number = false
  else
    vim.opt.number = true
  end
end, { desc = "Toggle absolute line numbers" })
