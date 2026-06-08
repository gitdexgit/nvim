local user_cache = {}
local group_cache = {}
local header_ns = vim.api.nvim_create_namespace("oil_header")

local function get_user(uid)
  if not user_cache[uid] then
    local name = vim.fn.trim(vim.fn.system("id -un " .. uid))
    user_cache[uid] = (vim.v.shell_error == 0) and name or tostring(uid)
  end
  return user_cache[uid]
end

local function get_group(gid)
  if not group_cache[gid] then
    local name = vim.fn.trim(vim.fn.system("id -gn " .. gid))
    group_cache[gid] = (vim.v.shell_error == 0) and name or tostring(gid)
  end
  return group_cache[gid]
end

-- Helper to draw the "." header line
local function update_oil_header()
  local ok, oil = pcall(require, "oil")
  if not ok or vim.bo.filetype ~= "oil" then return end

  local dir = oil.get_current_dir()
  if not dir then return end

  local stat = vim.loop.fs_stat(dir)
  if not stat then return end

  local perms = "drwxr-xr-x"
  local user = get_user(stat.uid)
  local group = get_group(stat.gid)
  local size = string.format("%.1fk", stat.size / 1024)
  local time = os.date("%b %d %H:%M", stat.mtime.sec)

  -- Format to match your column layout
  local header_str = string.format("%s %s %s %s %s   ./", perms, size, time, user, group)

  vim.api.nvim_buf_set_extmark(0, header_ns, 0, 0, {
    virt_lines = { { { header_str, "Comment" } } },
    virt_lines_above = true,
  })
end

_G.get_oil_winbar = function()
  local ok, oil = pcall(require, "oil")
  return ok and (oil.get_current_dir() or ""):gsub("oil://", "") or ""
end

return {
  'stevearc/oil.nvim',
  dependencies = { "nvim-tree/nvim-web-devicons" },
  init = function()
    -- Keybinds
    vim.keymap.set("n", "<leader>pv", function() require("oil").open() end)

    -- Auto-update header on enter
    vim.api.nvim_create_autocmd({ "BufWinEnter", "BufWritePost" }, {
      pattern = "oil://*",
      callback = function()
        vim.schedule(update_oil_header)
      end,
    })

    -- Dired prompt
    vim.keymap.set({ "n", "i" }, "<C-x>d", function()
      local buf_path = vim.api.nvim_buf_get_name(0)
      local base = buf_path:find("^oil://") and require("oil").get_current_dir() or (vim.fn.expand("%:p:h") .. "/")
      local path = vim.fn.input("Dired: ", vim.fn.fnamemodify(base, ":~"), "dir")
      if path ~= "" then require("oil").open(path) end
    end)
  end,
  opts = {
    win_options = {
      winbar = "%!v:lua.get_oil_winbar()",
    },
    columns = {
      {
        "permissions",
        render = function(entry)
          if entry.name == ".." then return "drwxr-xr-x" end
          return nil
        end,
      },
      "size",
      "mtime",
      {
        "owner",
        render = function(entry)
          local dir = require("oil").get_current_dir()
          local stat = vim.loop.fs_stat(dir .. entry.name)
          return stat and get_user(stat.uid) or ""
        end,
      },
      {
        "group",
        render = function(entry)
          local dir = require("oil").get_current_dir()
          local stat = vim.loop.fs_stat(dir .. entry.name)
          return stat and get_group(stat.gid) or ""
        end,
      },
      "icon",
    },
    view_options = {
      show_hidden = true,
      is_always_hidden = function() return false end,
    },
  },
}
