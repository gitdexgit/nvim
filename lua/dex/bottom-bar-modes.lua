-- 1. Many bars mode
vim.opt.laststatus = 2
-- vim.opt.showmode = false

-- 2. LSP Info Logic
_G.get_lsp_info = function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then return "" end
  local names = {}
  for _, client in ipairs(clients) do table.insert(names, client.name) end
  return " " .. table.concat(names, " ")
end

-- 3. Mode Logic
_G.get_mode = function()
  local modes = {
    n = "COMPOSE", i = "INSERT", v = "VISUAL", V = "V-LINE",
    c = "COMMAND", ["\22"] = "V-BLOCK",
  }
  return modes[vim.api.nvim_get_mode().mode] or "?"
end

-- 4. THE STATUSLINE
-- We put the Filename first (No %< here, so it stays)
-- We put the %< at the very end (This makes the right side the "sacrifice")

vim.opt.statusline =
    "U:%{&mod?'**':'--'}%{&ro?'@':'-'} %f" .. -- 1. Filename (STAYS)
    "  %P (%l,%c)  " ..                       -- 2. Cursor Info
    "%<" ..                                   -- 3. CUT STARTS HERE
    "(%{v:lua.get_mode()} %{&ft}%{v:lua.get_lsp_info()})" -- 4. Mode/LSP (DISAPPEARS FIRST)
