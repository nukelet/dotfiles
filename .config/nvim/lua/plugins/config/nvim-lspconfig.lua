return function()
    require('lspconfig').lua_ls.setup {}

    local protocol = require('vim.lsp.protocol')

    local on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("Format", { clear = true }),
            buffer = bufnr,
            callback = function() vim.lsp.buf.formatting_seq_sync() end
        })
    end

    --[[
    require("lspconfig").lua_ls.setup {
        on_attach = on_attach,
        settings = {
            Lua = {
                diagnostics = {
                    globals = { 'vim' },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                }
            }
        }
    }
    --]]
end
