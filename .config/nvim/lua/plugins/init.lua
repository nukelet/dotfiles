-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })

-------------------

-- Use 'mini.deps'. `now()` and `later()` are helpers for a safe two-stage
-- startup and are optional.
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later


now(function()
    require('mini.notify').setup()
    vim.notify = require('mini.notify').make_notify()
end)

now(function() require('mini.icons').setup() end)
now(function() require('mini.tabline').setup() end)
now(function() require('mini.statusline').setup() end)

later(function() require('mini.ai').setup() end)
later(function() require('mini.comment').setup() end)

later(function()
    local miniclue = require('mini.clue')
    miniclue.setup({
        triggers = {
            -- Leader triggers
            { mode = 'n', keys = '<Leader>' },
            { mode = 'x', keys = '<Leader>' },

            -- Built-in completion
            { mode = 'i', keys = '<C-x>' },

            -- `g` key
            { mode = 'n', keys = 'g' },
            { mode = 'x', keys = 'g' },

            -- Marks
            { mode = 'n', keys = "'" },
            { mode = 'n', keys = '`' },
            { mode = 'x', keys = "'" },
            { mode = 'x', keys = '`' },

            -- Registers
            { mode = 'n', keys = '"' },
            { mode = 'x', keys = '"' },
            { mode = 'i', keys = '<C-r>' },
            { mode = 'c', keys = '<C-r>' },

            -- Window commands
            { mode = 'n', keys = '<C-w>' },

            -- `z` key
            { mode = 'n', keys = 'z' },
            { mode = 'x', keys = 'z' },
        },

        clues = {
            -- Enhance this by adding descriptions for <Leader> mapping groups
            miniclue.gen_clues.builtin_completion(),
            miniclue.gen_clues.g(),
            miniclue.gen_clues.marks(),
            miniclue.gen_clues.registers(),
            miniclue.gen_clues.windows(),
            miniclue.gen_clues.z(),
        },
    })
end)

later(function() require('mini.pick').setup() end)
later(function() require('mini.surround').setup() end)
later(function() require('mini.pairs').setup() end)
later(function()
    require('mini.files').setup()
    vim.keymap.set('n', '<Leader>e', MiniFiles.open)
end)

later(function()
    add({
        source = 'bluz71/vim-moonfly-colors',
    })

    vim.cmd [[colorscheme moonfly]]
end)

later(function()
    add({
        source = 'lukas-reineke/indent-blankline.nvim'
    })

    require('ibl').setup({
        scope = { enabled = false },
    })
end)

later(function()
    add({
        source = 'nvim-telescope/telescope.nvim',
        depends = { 'nvim-lua/plenary.nvim' },
    })

    require('telescope').setup()
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
end)

later(function()
    add({
        source = 'nvim-treesitter/nvim-treesitter',
        -- Use 'master' while monitoring updates in 'main'
        checkout = 'master',
        monitor = 'main',
        -- Perform action after every checkout
        hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
    })

    require('nvim-treesitter.configs').setup {
        ensure_installed = { 'c', 'cpp', 'lua', 'rust', 'python', 'go', },
        sync_install = false,
        auto_install = true,

        highlight = {
            enable = true,
            disable = { 'latex' },
            additional_vim_regex_highlighting = false,
        }
    }
end)

-- these are configured separately, inside lua/lsp, in order to
-- not pollute the main plugin config file
now(function()
    add({ source = 'williamboman/mason.nvim' })
    add({ source = 'williamboman/mason-lspconfig.nvim' })
    add({ source = 'neovim/nvim-lspconfig' })
    add({ source = 'hrsh7th/nvim-cmp' })
    add({ source = 'hrsh7th/cmp-nvim-lsp' })
    add({ source = 'saadparwaiz1/cmp_luasnip' })
    add({
        source = 'L3MON4D3/LuaSnip',
        checkout = 'v2.3.0',
        monitor = 'master'
    })
    require('plugins.lsp')
end)
