-- vim.opt.laststatus = 3
-- vim.opt.showmode = false

_G.get_lsp_info = function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then return "" end
  local names = {}
  for _, client in ipairs(clients) do
    table.insert(names, client.name)
  end
  return " " .. table.concat(names, " ")
end

_G.get_mode = function()
  local modes = {
    n  = "COMPOSE",  i  = "INSERT",  v  = "VISUAL",
    V  = "V-LINE",  c  = "COMMAND", R  = "REPLACE",
    t  = "TERM",    s  = "SELECT",  no = "OP-PEND",
    ["\22"] = "V-BLOCK",
  }
  return modes[vim.api.nvim_get_mode().mode] or "?"
end

vim.opt.statusline = "U:%{&mod?'**':'--'}%{&ro?'@':'-'} %t  %P  (%l,%c)  (%{v:lua.get_mode()} %{&ft}%{v:lua.get_lsp_info()})"
