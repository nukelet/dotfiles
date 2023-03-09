local options = require('options')
local plugins = require('plugins')

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

lsp = require('plugins.lsp')

--[[
require('mason').setup()
require('mason-lspconfig').setup()
require('lspconfig').lua_ls.setup {}
--]]
