local opt = vim.opt

opt.smarttab = true  -- intelligently use the tab key to insert whitespaces
opt.shiftwidth = 4   -- tabs insert 4 whitespaces
opt.expandtab = true -- enable the use of space in tab

opt.tabstop = 8      -- make actual tabs visually look like 8 whitespaces
opt.softtabstop = 0

opt.preserveindent = true -- preserve indentation as much as possible
opt.copyindent = true     -- copy previous indentation on autoindenting

opt.cursorline = true     -- highlight the line the cursor is at
opt.number = true         -- show line number
opt.relativenumber = true -- show relative line number

opt.fileencoding = "utf-8"
opt.termguicolors = true -- enable 24-bit RGB in the TUI

opt.writebackup = false  -- disable making a backup before overwriting a file

opt.clipboard = 'unnamedplus'

opt.updatetime = 250

-- used by which-key
vim.o.timeout = true
vim.o.timeoutlen = 500
