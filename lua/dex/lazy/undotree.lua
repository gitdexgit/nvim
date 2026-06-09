
return {
    "mbbill/undotree",

    config = function()
        vim.keymap.set("n", "<leader>U", vim.cmd.UndotreeToggle)
        vim.g.undotree_DisabledFiletypes = { 'TelescopePrompt', 'toggleterm' }
    end
}


