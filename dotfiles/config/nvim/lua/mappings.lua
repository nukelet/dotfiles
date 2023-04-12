vim.g.mapleader = " "
vim.g.maplocalleader = " "

local function map(mode, lhs, rhs, desc, opts)
    local options = { noremap = true, desc = desc }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

map("n", "<leader>e", "<cmd>Neotree toggle<CR>", "Toggle filetree")

map("n", "<S-h>", "<cmd>bp<CR>", "Previous buffer")
map("n", "<S-l>", "<cmd>bn<CR>", "Next buffer")


-- map("n", "<localleader>li", "<Plug>(vimtex-info)<CR>", {desc = "Display info" })

local function vimtex_whichkey()
    local wk = require("which-key")
    map("n", "csd", "<Plug>(vimtex-delim-change-math)", { desc = "Change surrounding delimiters" })
    local mappings = {
        -- vimtex stuff
        l = {
            name = "Vimtex",
            i = { "<Plug>(vimtex-info)<CR>", "Display info" },
            l = { "<Plug>(vimtex-compile)<CR>", "Compile" },
        },
    }
    local opts = {
        prefix = "<localleader>",
        mode = "n",
        buffer = 0, -- current buffer only
    }
    wk.register(mappings, opts)
end


local function lsp_keymaps(ev)
    -- buffer local mappings
    local opts = { buffer = ev.buf }
    local buf = vim.lsp.buf
    map("n", "<leader>gD", buf.declaration, "Go to declaration", opts)
    map("n", "<leader>gd", buf.definition, "Go to definition", opts)
    map("n", "<leader>gi", buf.implementation, "Go to implementation", opts)
    map("n", "<leader>gr", buf.references, "References", opts)
    map("n", "<leader>k", buf.hover, "Hover", opts)
    map("n", "<leader>K", buf.signature_help, "Signature help", opts)
    map("n", "<leader>r", buf.rename, "Rename", opts)
    map("n", "<leader>D", buf.type_definition, "Type definition", opts)
    map({ "n", "v" }, "<leader>ca", buf.code_action, "Code action", opts)
end

-- TODO: refactor this into Lua?
local function luasnip_keymaps()
    vim.cmd [[
" Use Tab to expand and jump through snippets
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
smap <silent><expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>'

" Use Shift-Tab to jump backwards through snippets
imap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
smap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
]]
end

return {
    vimtex_whichkey = vimtex_whichkey,
    lsp_keymaps = lsp_keymaps,
    luasnip_keymaps = luasnip_keymaps,
}
