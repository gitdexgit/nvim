return {
    'mg979/vim-visual-multi',
    branch = 'master',
    init = function()
        vim.g.VM_maps = {
            ['Find Under']    = '<leader>>',
            ['Find Prev']     = '<leader><',
            ['Skip Region']   = '<C-|>',     -- Skip next
            ['Remove Region'] = '<C-S-q>',   -- VM lacks "skip back", use remove
        }
    end,
    config = function()
        -- Normal mode
        vim.keymap.set('n', '<C-S-c><C-S-c>', '<Plug>(VM-Add-Cursor-At-Pos)')

        -- Insert mode
        vim.keymap.set('i', '<C-x>>', '<Plug>(VM-Find-Under)')
        vim.keymap.set('i', '<C-x><', '<Plug>(VM-Find-Prev)')
        -- Skip in Insert
        vim.keymap.set('i', '<C-x>|', '<Plug>(VM-Skip-Region)')
    end
}
