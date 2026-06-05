return {
    'mg979/vim-visual-multi',
    branch = 'master',
    init = function()
        -- Define your custom mappings here
        vim.g.VM_maps = {
            ['Add Cursor Down']             = '<A-J>',
            ['Add Cursor Up']               = '<A-K>',
            ['Select Cursor Down']          = '<C-A-j>', -- Optional: Alt+Shift+J to select lines down
            ['Select Cursor Up']            = '<C-A-k>', -- Optional: Alt+Shift+K to select lines up
        }
    end
}
