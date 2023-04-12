-- packer bootstrapping
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

local function get_config(name)
    return string.format('require(\'plugins/config/%s\')', name)
end

-- Automatically run :PackerCompile whenever plugins.lua is updated with an autocommand:
-- vim.api.nvim_create_autocmd('BufWritePost', { group = vim.api.nvim_create_augroup('PACKER', { clear = true }), pattern = 'plugins.lua', command = 'source <afile> | PackerCompile', })

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    -- My plugins here
    -- use 'foo1/bar1.nvim'
    -- use 'foo2/bar2.nvim'

    use 'jiangmiao/auto-pairs'

    use {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end
    }

    use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = get_config("neo-tree"),
    }

    use {
        "akinsho/bufferline.nvim",
        tag = "v3.*",
        requires = "nvim-tree/nvim-web-devicons",
    }

    use {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
        'hrsh7th/nvim-cmp',         -- Autocompletion plugin
        'hrsh7th/cmp-nvim-lsp',     -- LSP source for nvim-cmp
        'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp
        'L3MON4D3/LuaSnip',         -- Snippets plugin
    }

    use {
        "lervag/vimtex",
    }

    use "ellisonleao/gruvbox.nvim"
    use "lukas-reineke/indent-blankline.nvim"

    use {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup {

            }
        end
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
