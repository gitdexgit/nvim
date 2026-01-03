require("dex.set")
-- require("dex.tab_line")
require("dex.remap")
require("dex.clipboard")
require("dex.lazy_init")

local augroup = vim.api.nvim_create_augroup
local ThePrimeagenGroup = augroup("ThePrimeagen", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

local markdown_augroup = vim.api.nvim_create_augroup("MarkdownSettings", { clear = true })

autocmd("FileType", {
	group = markdown_augroup,
	pattern = "markdown",
	callback = function()
		vim.opt_local.wrap = true
	end,
	desc = "Enable word wrap for Markdown files",
})

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
			timeout = 40,
		})
	end,
})

autocmd({ "BufWritePre" }, {
	group = ThePrimeagenGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

autocmd("BufEnter", {
	group = ThePrimeagenGroup,
	callback = function()
		if vim.bo.filetype == "zig" then
			pcall(vim.cmd.colorscheme, "tokyonight-night")
		else
			pcall(vim.cmd.colorscheme, "rose-pine-moon")
		end
	end,
})

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
		vim.keymap.set("i", "<C-h>", function()
			vim.lsp.buf.signature_help()
		end, opts)
		vim.keymap.set("n", "[d", function()
			vim.diagnostic.goto_next()
		end, opts)
		vim.keymap.set("n", "]d", function()
			vim.diagnostic.goto_prev()
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
        vim.api.nvim_set_hl(0, 'TabNumRed', { fg = '#ff5555', bg = '#3b4252', bold = true })
        vim.api.nvim_set_hl(0, 'TabNumRedSel', { fg = '#ff5555', bg = '#4c566a', bold = true })
        vim.api.nvim_set_hl(0, 'WinNumBlue', { fg = '#8be9fd', bg = '#3b4252' })
        vim.api.nvim_set_hl(0, 'WinNumBlueSel', { fg = '#8be9fd', bg = '#4c566a' })
        vim.api.nvim_set_hl(0, 'ModifiedGreen', { fg = '#50fa7b', bg = '#3b4252' })
        vim.api.nvim_set_hl(0, 'ModifiedGreenSel', { fg = '#50fa7b', bg = '#4c566a' })

        -- NEW: Yellow for the Alternate Tab
        -- vim.api.nvim_set_hl(0, 'AltTabYellow', { fg = '#f1fa8c', bg = '#3b4252', italic = true })
    end,
})
vim.cmd('doautocmd ColorScheme')

function MyTabLine()
  local s = ''
  local alternate_tab = vim.fn.tabpagenr('#') -- Get the last accessed tab

  for i = 1, vim.fn.tabpagenr('$') do
    local is_selected = (i == vim.fn.tabpagenr())
    local is_alternate = (i == alternate_tab)
    local hl = is_selected and 'Sel' or ''

    s = s .. (is_selected and '%#TabLineSel#' or '%#TabLine#')
    s = s .. '%' .. i .. 'T '

    -- A. Tab Number in Red with ()
    s = s .. '%#TabNumRed' .. hl .. '#(' .. i .. ')%*'
    s = s .. (is_selected and '%#TabLineSel#' or '%#TabLine#')

    -- B. Window Number in Blue (on the left)
    local win_ids = vim.api.nvim_tabpage_list_wins(i)
    local normal_win_count = 0
    for _, win_id in ipairs(win_ids) do
        if vim.api.nvim_win_get_config(win_id).relative == "" then
            normal_win_count = normal_win_count + 1
        end
    end
    if normal_win_count > 1 then
        s = s .. ' %#WinNumBlue' .. hl .. '#' .. normal_win_count .. '%*'
        s = s .. (is_selected and '%#TabLineSel#' or '%#TabLine#')
    end

    -- C. Filename (Yellow if alternate, with a * symbol)
    local buflist = vim.fn.tabpagebuflist(i)
    local winnr = vim.fn.tabpagewinnr(i)
    local bufnr = buflist[winnr]
    local bufname = vim.fn.bufname(bufnr)
    local filename = (bufname ~= '' and vim.fn.fnamemodify(bufname, ':t') or '[No Name]')

    if is_alternate and not is_selected then
        s = s .. ' %#AltTabYellow#[' .. filename .. ' *]%*'
    else
        s = s .. ' [' .. filename .. '] '
    end

    -- D. Modified Sign in Green
    local modified = false
    for _, b in ipairs(buflist) do
        if vim.fn.getbufvar(b, '&modified') == 1 then
            modified = true
            break
        end
    end
    if modified then
        s = s .. '%#ModifiedGreen' .. hl .. '#+%* '
    end
  end

  s = s .. '%#TabLineFill#%T'
  return s
end

vim.opt.tabline = '%!v:lua.MyTabLine()'


