local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
    -- ... Your other configuration ...

    mapping = {
        -- ... Your other mappings ...

        ["<Tab>"] = cmp.mapping(function(fallback)
            -- if cmp.visible() then
            --     cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- they way you will only jump inside the snippet region
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            -- if cmp.visible() then
            --     cmp.select_prev_item()
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        -- ... Your other mappings ...
    },
    -- ... Your other configuration ...
})

luasnip.setup({
    enable_autosnippets = true,
    update_events = "TextChanged,TextChangedI",
    store_selection_keys = "<Tab>",
})
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/luasnippets" })
