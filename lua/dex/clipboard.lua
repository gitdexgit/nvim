-- ~/.config/nvim/lua/dex/clipboard.lua

local function smart_copy(lines)
    local str = table.concat(lines, "\n")

    -- 1. Handle Tmux (if active)
    if vim.env.TMUX then
        vim.fn.system("tmux load-buffer -w -", str)
    end

    -- 2. Handle System Clipboard (if xclip exists and DISPLAY is set)
    if vim.fn.executable("xclip") == 1 and vim.env.DISPLAY then
        vim.fn.system("xclip -selection clipboard", str)
    end

    -- 3. SSH/Termux Bridge (Keep your existing logic)
    local job = vim.fn.jobstart(
        "ssh -o ConnectTimeout=1 -i ~/.ssh/id_ed25519 -p 8022 u0_a662@100.126.224.121 termux-clipboard-set",
        { detach = true }
    )
    vim.fn.chansend(job, str)
    vim.fn.chanclose(job, "stdin")
end

local function smart_paste()
    -- Try xclip first
    if vim.fn.executable("xclip") == 1 and vim.env.DISPLAY then
        local out = vim.fn.systemlist("xclip -selection clipboard -o")
        if vim.v.shell_error == 0 then return out end
    end

    -- Fallback to Tmux
    if vim.env.TMUX then
        return vim.fn.systemlist("tmux save-buffer -")
    end

    return {}
end

vim.g.clipboard = {
    name = "smart-bridge",
    copy = { ["+"] = smart_copy, ["*"] = smart_copy },
    paste = { ["+"] = smart_paste, ["*"] = smart_paste },
    cache_enabled = 1,
}

if os.getenv("UVIM_MODE") == "true" then
    vim.opt.clipboard = ""
    vim.opt.lazyredraw = true
end
