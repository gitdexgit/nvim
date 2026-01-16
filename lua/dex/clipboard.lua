-- make sure this is at the top
vim.g.clipboard = "osc52"

-- ==========================================================================
-- UVIM: MANUAL CLIPBOARD (XCLIP ONLY, NO AUTO-SYNC)
-- ==========================================================================

if os.getenv("UVIM_MODE") == "true" then
    -- 1. Explicitly define xclip for the "+" and "*" registers
    -- This ensures that manual "+y and "+p use xclip
    vim.g.clipboard = {
        name = 'xclip-manual',
        copy = {
            ['+'] = 'xclip -selection clipboard',
            ['*'] = 'xclip -selection primary',
        },
        paste = {
            ['+'] = 'xclip -selection clipboard -o',
            ['*'] = 'xclip -selection primary -o',
        },
        cache_enabled = 1,
    }

    -- 2. DISABLE unnamedplus
    -- This keeps your internal Neovim yanks separate from your system clipboard
    vim.opt.clipboard = ""

    -- 3. Performance tweak for URXVT
    vim.opt.lazyredraw = true

    -- Optional: Notify you that you are in manual mode
    -- print("UVIM: Manual xclip enabled (No Auto-sync)")
end














