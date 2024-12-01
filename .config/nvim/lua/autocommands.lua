if require("which-key") then
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
        pattern = { "*.tex" },
        callback = require("mappings").vimtex_whichkey,
    })
end

vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    group = "Packer",
    pattern = "*/nvim/lua/plugins/init.lua",
    command = "source <afile> | PackerCompile",
})

local function open_diagnostics_if_no_float()
    for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_config(winid).zindex then
            return
        end
    end

    vim.diagnostic.open_float(0, {
        scope = "cursor",
        focusable = false,
        close_events = {
            "CursorMoved",
            "CursorMovedI",
            "BufHidden",
            "InsertCharPre",
            "WinLeave",
        },
    })
end

vim.api.nvim_create_augroup("lsp_diagnostics_hold", { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold" }, {
    pattern = "*",
    callback = open_diagnostics_if_no_float,
    group = "lsp_diagnostics_hold",
})

vim.api.nvim_create_augroup("user_lsp_config", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
    group = "user_lsp_config",
    callback = require("mappings").lsp_keymaps,
})

-- treesitter workaround
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufAdd', 'BufNew', 'BufNewFile', 'BufWinEnter' }, {
    group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
    callback = function()
        vim.opt.foldmethod = 'expr'
        vim.opt.foldexpr   = 'nvim_treesitter#foldexpr()'
    end
})
