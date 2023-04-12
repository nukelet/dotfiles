local mappings = require('mappings')

local options = require('options')
local plugins = require('plugins')

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])
require("bufferline").setup()

local lsp = require('plugins.lsp')
local autocommands = require('autocommands')
-- local snippets = require("snippets")
