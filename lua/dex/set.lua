
vim.opt.guicursor = ""
vim.g.markdown_recommended_style = 0

-- -opts- This so that espanso can move the cursor to position so espanso snippets work in insert mode
vim.opt.whichwrap:append("[,]")

-- idk what this is even for
-- vim.g.maplocalleader = " "

-- vim.opt.timeoutlen = 500   -- Time to wait for a mapped sequence (e.g. your own shortcuts)
-- vim.opt.ttimeoutlen = 0   -- Time to wait for a key code (this fixes the Esc delay)

vim.opt.ttimeoutlen = 0
vim.opt.timeoutlen = 375


vim.opt.showtabline = 1

vim.opt.spelllang = 'en'
vim.opt.spell = false

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true


vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

-- whateven is this
-- vim.opt.listchars = 'tab:▸\\ ,trail:·,space:·,extends:»,precedes:«'



--- setting up find command

