-- ~/.config/nvim/lua/dex/clipboard.lua

-- Function to handle yanking through tmux to the system clipboard
local function tmux_system_copy(lines)
    -- Join lines and send to tmux buffer
    local str = table.concat(lines, '\n')
    -- 1. Load the data into tmux's buffer
    -- 2. Use tmux's set-clipboard logic to push to the terminal
    -- 3. Also try to pipe to xclip as a backup
    local copy_command = "tmux load-buffer -w - && tmux show-buffer | xclip -selection clipboard"
    vim.fn.system(copy_command, str)
end

-- Function to handle pasting from system clipboard via tmux
local function tmux_system_paste()
    -- Try to get from xclip first, fallback to tmux buffer
    local paste_command = "xclip -selection clipboard -o || tmux save-buffer -"
    local result = vim.fn.systemlist(paste_command)
    return result
end

vim.g.clipboard = {
    name = 'tmux-popup-bridge',
    copy = {
        ['+'] = tmux_system_copy,
        ['*'] = tmux_system_copy,
    },
    paste = {
        ['+'] = tmux_system_paste,
        ['*'] = tmux_system_paste,
    },
    cache_enabled = 1,
}

if os.getenv("UVIM_MODE") == "true" then
    vim.opt.clipboard = ""
    vim.opt.lazyredraw = true
end
