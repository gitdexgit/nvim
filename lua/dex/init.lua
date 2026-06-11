require("dex.set")
-- require("dex.tab_line")
require("dex.clipboard")
require("dex.remap")
require("dex.bottom-bar-modes")
require("dex.lazy_init")



-----------------------------------------------------------------------------------------------------------
--- Cursor movements - Cursor keep location for Copying stuff and duplicating stuff and yanking stuff
-----------------------------------------------------------------------------------------------------------
local function duplicate_smart()
  local mode = vim.api.nvim_get_mode().mode
  local cur = vim.api.nvim_win_get_cursor(0)

  if mode:match("[vV\22]") then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
    vim.schedule(function()
      local start_line = vim.api.nvim_buf_get_mark(0, "<")[1]
      local end_line = vim.api.nvim_buf_get_mark(0, ">")[1]
      local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
      vim.api.nvim_buf_set_lines(0, end_line, end_line, false, lines)
      pcall(vim.api.nvim_win_set_cursor, 0, {end_line + 1, cur[2]})
    end)
  else
    local line_content = vim.api.nvim_get_current_line()
    vim.api.nvim_buf_set_lines(0, cur[1], cur[1], false, {line_content})
    pcall(vim.api.nvim_win_set_cursor, 0, {cur[1] + 1, cur[2]})
  end
end

-- Duplicate
vim.keymap.set('n', '<leader>,', duplicate_smart) -- think of leader as onetap(conrol)
vim.keymap.set('v', '<leader>,', duplicate_smart)
vim.keymap.set('i', '<C-x>,', duplicate_smart) -- can't do <C-,> cuz terminal can't send. terminal dumb

-- Shorcuts for commenting lines
vim.keymap.set('n', '<leader>;', 'gcc', { remap = true }) -- think of leader as onetap(conrol)
vim.keymap.set('v', '<leader>;', 'gc', { remap = true })
vim.keymap.set('i', '<C-x>;', '<C-o>gcc', { remap = true }) -- can't do <C-;> cuz terminal can't send. terminal dumb


-- Yank no move (Clipboard)
vim.keymap.set('v', '<leader>y', function()
  local cur = vim.api.nvim_win_get_cursor(0)
  vim.cmd('normal! "+y')
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
  vim.schedule(function() pcall(vim.api.nvim_win_set_cursor, 0, cur) end)
end)

vim.keymap.set('n', '<leader>Y', function()
  local cur = vim.api.nvim_win_get_cursor(0)
  vim.cmd('normal! "+Y')
  pcall(vim.api.nvim_win_set_cursor, 0, cur)
end)

-- Yank no move (Local)
vim.keymap.set('v', 'y', function()
  local cur = vim.api.nvim_win_get_cursor(0)
  vim.cmd('normal! y')
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
  vim.schedule(function() pcall(vim.api.nvim_win_set_cursor, 0, cur) end)
end)

-- Comment no move
vim.keymap.set('n', 'gcc', function()
  local cur = vim.api.nvim_win_get_cursor(0)
  require("vim._comment").toggle_lines(cur[1], cur[1])
  pcall(vim.api.nvim_win_set_cursor, 0, cur)
end)

vim.keymap.set('x', 'gc', function()
  local cur = vim.api.nvim_win_get_cursor(0)
  local s = math.min(vim.fn.line("v"), vim.fn.line("."))
  local e = math.max(vim.fn.line("v"), vim.fn.line("."))
  require("vim._comment").toggle_lines(s, e)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
  pcall(vim.api.nvim_win_set_cursor, 0, cur)
end)
------
--END
------







local function get_buf_dir()
    local dir = vim.fn.expand("%:p:h"):gsub("oil://", "")
    return vim.fn.shellescape(dir)
end

-- Core: Run shell in buffer dir
local function run_shell(insert)
    vim.ui.input({ prompt = "Shell command: " }, function(cmd)
        if not cmd or cmd == "" then return end

        local dir = get_buf_dir()
        if insert then
            -- Run, capture, insert at cursor
            -- Run, capture, insert at cursor
            local full_cmd = string.format("cd %s && %s", dir, cmd)
            local out = vim.fn.systemlist(full_cmd)
            vim.api.nvim_put(out, "l", true, true)
        else
            -- Run interactive
            vim.cmd(string.format("!cd %s && %s", dir, cmd))
        end
    end)
end

-- M-! : Run in buffer dir
vim.keymap.set("n", "<M-!>", function() run_shell(false) end)
vim.keymap.set("i", "<C-o><M-!>", function() run_shell(false) end)

-- M-u M-! : Run + Insert (Emacs style)
vim.keymap.set({ "n", "i" }, "<M-u><M-!>", function() run_shell(true) end)

-- Leader variants
vim.keymap.set("n", "<leader>!", function() run_shell(false) end)
vim.keymap.set("n", "<leader>u!", function() run_shell(true) end)

-- CWD logic to save recent CWD so <leader>cd is smart
local hist = vim.fn.stdpath("data") .. "/cwd_history"

-- Log CWD
vim.api.nvim_create_autocmd({"DirChanged", "VimEnter"}, {
  callback = function()
    local path = vim.fn.getcwd()
    local f = io.open(hist, "a")
    if f then
      f:write(path .. "\n")
      f:close()
    end
  end,
})

local hist = vim.fn.stdpath("data") .. "/cwd_history"

-- Log CWD
vim.api.nvim_create_autocmd({"DirChanged", "VimEnter"}, {
  callback = function()
    local path = vim.fn.getcwd()
    local f = io.open(hist, "a")
    if f then
      f:write(path .. "\n")
      f:close()
    end
  end,
})

-- Map leader zr
vim.keymap.set('n', '<leader>cd', function()
  local cmd = string.format("tac %s | awk '!seen[$0]++' | head -n 6", hist)

  require('fzf-lua').fzf_exec(cmd, {
    winopts = { title = " Recent Dirs " },
    -- Preview: ls -1 (list), -p (add / to dirs), --color (pretty)
    preview = "ls -la -1p --color=always --group-directories-first {}",
    actions = {
      ['default'] = function(selected)
        if selected[1] then
          local path = selected[1]
          vim.cmd("cd " .. path)
          require('oil').open(path) -- Open Oil in new CWD
        end
      end
    }
  })
end, { desc = "Recent CWD with Oil" })


-- Force Neovim to prioritize the parsers installed by Lazy <--- Remove this test if it makes tresesiter stop the errorr
-- vim.opt.runtimepath:prepend(vim.fn.stdpath("data") .. "/lazy/nvim-treesitter")

-- Consolidated Markdown & Spell Settings
local markdown_spell_group = vim.api.nvim_create_augroup("MarkdownSpell", { clear = true })

-- vim.api.nvim_create_autocmd("FileType", {
-- 	group = markdown_spell_group,
-- 	pattern = { "markdown", "md", "text" },
-- 	callback = function()
-- 		vim.opt_local.spell = true
-- 		vim.opt_local.spelllang = "en"
-- 		vim.opt_local.shiftwidth = 3
-- 		vim.opt_local.tabstop = 3
-- 		vim.opt_local.wrap = true
-- 		-- ADD THESE LINES:
-- 		vim.opt_local.smartindent = false
-- 		vim.opt_local.autoindent = false
-- 		vim.opt_local.indentexpr = ""
-- 	end,
-- })

-- 1. Add this to top of file (outside any function)
-- vim.g.markdown_folding = 1

-- 2. Update your existing group
vim.api.nvim_create_autocmd("FileType", {
	group = markdown_spell_group,
	pattern = { "markdown", "md" },
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en"
		vim.opt_local.shiftwidth = 3
		vim.opt_local.tabstop = 3
		vim.opt_local.wrap = true
		vim.opt_local.smartindent = false
		vim.opt_local.autoindent = false
		vim.opt_local.indentexpr = ""

		-- FOLDING CONFIG
		-- vim.opt_local.foldmethod = "expr"
		-- Use native TS foldexpr (NVIM 0.10+)
		-- vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		-- vim.opt_local.foldlevel = 99
	end,
})

vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
	group = markdown_spell_group,
	pattern = "markdown",
	callback = function()
		vim.schedule(function()
			vim.opt_local.foldmethod = "expr"
			vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.opt_local.foldlevel = 99
			-- vim.keymap.set("n", "<Tab>", "za", { buffer = true, remap = false })
		end)
	end,
})

-- This ensures the red highlight stays even when you switch themes
-- vim.api.nvim_create_autocmd("ColorScheme", {
--   group = markdown_spell_group,
--   pattern = "*",
--   callback = function()
--     vim.api.nvim_set_hl(0, "SpellBad", { fg = "#ff5555", sp = "#ff5555", underline = true, bold = true })
--     vim.api.nvim_set_hl(0, "SpellCap", { fg = "#f1fa8c", sp = "#f1fa8c", underline = true })
--   end,
-- })

local augroup = vim.api.nvim_create_augroup
local ThePrimeagenGroup = augroup("ThePrimeagen", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

function R(name)
	require("plenary.reload").reload_module(name)
end

vim.filetype.add({
	extension = {
		templ = "templ",
	},
})

autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 65,
		})
	end,
})

autocmd({ "BufWritePre" }, {
	group = ThePrimeagenGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

-- autocmd("BufEnter", {
-- 	group = ThePrimeagenGroup,
-- 	callback = function()
-- 		if vim.bo.filetype == "zig" then
-- 			pcall(vim.cmd.colorscheme, "tokyonight-night")
-- 		else
-- 			pcall(vim.cmd.colorscheme, "rose-pine-moon")
-- 		end
-- 	end,
-- })

-- NEW VERSION
-- autocmd("BufEnter", {
--     group = ThePrimeagenGroup,
--     callback = function()
--         if vim.bo.filetype == "zig" then
--         --     ColorMyPencils("tokyonight-night")
--         -- else
--             ColorMyPencils("rose-pine-moon")
--         end
--     end,
-- })

autocmd("LspAttach", {
	group = ThePrimeagenGroup,
	callback = function(e)
		local opts = { buffer = e.buf }
		vim.keymap.set("n", "gd", function()
			vim.lsp.buf.definition()
		end, opts)
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover()
		end, opts)
		vim.keymap.set("n", "<leader>vws", function()
			vim.lsp.buf.workspace_symbol()
		end, opts)
		vim.keymap.set("n", "<leader>vd", function()
			vim.diagnostic.open_float()
		end, opts)
		vim.keymap.set("n", "<leader>vca", function()
			vim.lsp.buf.code_action()
		end, opts)
		vim.keymap.set("n", "<leader>vrr", function()
			vim.lsp.buf.references()
		end, opts)
		vim.keymap.set("n", "<leader>vrn", function()
			vim.lsp.buf.rename()
		end, opts)
		vim.keymap.set("i", "<C-S-h>", function()
			vim.lsp.buf.signature_help()
		end, opts)

		vim.keymap.set("n", "[d", function()
			vim.diagnostic.jump({ count = -1 })
		end, opts)

		vim.keymap.set("n", "]d", function()
			vim.diagnostic.jump({ count = 1 })
		end, opts)
	end,
})

-- Enable relative line numbers in netrw file explorer
autocmd("FileType", {
	pattern = "netrw",
	callback = function()
		vim.opt_local.relativenumber = true
		vim.opt_local.number = true
	end,
	desc = "Enable relative line numbers in netrw",
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

--#My tab when I do use tab sometimes I do. Helps visualize Harpoon even if not
--#going to the tab

-- 1. Updated Colors (Added Yellow for the Alternate Tab)
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		vim.api.nvim_set_hl(0, "TabNumRed", { fg = "#ff5555", bg = "#3b4252", bold = true })
		vim.api.nvim_set_hl(0, "TabNumRedSel", { fg = "#ff5555", bg = "#4c566a", bold = true })
		vim.api.nvim_set_hl(0, "WinNumBlue", { fg = "#8be9fd", bg = "#3b4252" })
		vim.api.nvim_set_hl(0, "WinNumBlueSel", { fg = "#8be9fd", bg = "#4c566a" })
		vim.api.nvim_set_hl(0, "ModifiedGreen", { fg = "#50fa7b", bg = "#3b4252" })
		vim.api.nvim_set_hl(0, "ModifiedGreenSel", { fg = "#50fa7b", bg = "#4c566a" })

		-- NEW: Yellow for the Alternate Tab
		-- vim.api.nvim_set_hl(0, 'AltTabYellow', { fg = '#f1fa8c', bg = '#3b4252', italic = true })
	end,
})
vim.cmd("doautocmd ColorScheme")

function MyTabLine()
	local s = ""
	local alternate_tab = vim.fn.tabpagenr("#") -- Get the last accessed tab

	for i = 1, vim.fn.tabpagenr("$") do
		local is_selected = (i == vim.fn.tabpagenr())
		local is_alternate = (i == alternate_tab)
		local hl = is_selected and "Sel" or ""

		s = s .. (is_selected and "%#TabLineSel#" or "%#TabLine#")
		s = s .. "%" .. i .. "T "

		-- A. Tab Number in Red with ()
		s = s .. "%#TabNumRed" .. hl .. "#(" .. i .. ")%*"
		s = s .. (is_selected and "%#TabLineSel#" or "%#TabLine#")

		-- B. Window Number in Blue (on the left)
		local win_ids = vim.api.nvim_tabpage_list_wins(i)
		local normal_win_count = 0
		for _, win_id in ipairs(win_ids) do
			if vim.api.nvim_win_get_config(win_id).relative == "" then
				normal_win_count = normal_win_count + 1
			end
		end
		if normal_win_count > 1 then
			s = s .. " %#WinNumBlue" .. hl .. "#" .. normal_win_count .. "%*"
			s = s .. (is_selected and "%#TabLineSel#" or "%#TabLine#")
		end

		-- C. Filename (Yellow if alternate, with a * symbol)
		local buflist = vim.fn.tabpagebuflist(i)
		local winnr = vim.fn.tabpagewinnr(i)
		local bufnr = buflist[winnr]
		local bufname = vim.fn.bufname(bufnr)
		local filename = (bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "[No Name]")

		if is_alternate and not is_selected then
			s = s .. " %#AltTabYellow#[" .. filename .. " *]%*"
		else
			s = s .. " [" .. filename .. "] "
		end

		-- D. Modified Sign in Green
		local modified = false
		for _, b in ipairs(buflist) do
			if vim.fn.getbufvar(b, "&modified") == 1 then
				modified = true
				break
			end
		end
		if modified then
			s = s .. "%#ModifiedGreen" .. hl .. "#+%* "
		end
	end

	s = s .. "%#TabLineFill#%T"
	return s
end

vim.opt.tabline = "%!v:lua.MyTabLine()"
