local M = {}

function M.setup()
    local packer_bootstrap = false

    local conf = {
        profile = {
            enable = true,
            threadhold = 1,
        },
        display = {
            open_fn = function()
                return require("packer.util").float { border = "rounded" }
            end,
        },
    }

    -- check if packer.nvim is installed
    local function packer_init()
        local fn = vim.fn
        local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
        if fn.empty(fn.glob(install_path)) > 0 then
            packer_bootstrap = fn.system {
                "git",
                "clone",
                "--depth",
                "1",
                "https://github.com/wbthomason/packer.nvim",
                install_path,
            }
            vim.cmd [[packadd packer.nvim]]
        end;
        vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
    end

    -- Plugins
    local function plugins(use)
        use { "wbthomason/packer.nvim" }
        
        -- Load only when require
        use { "nvim-lua/plenary.nvim", module = "plenary" }

        -- Colorscheme
        use {
            "sainnhe/everforest",
            config = function()
                vim.cmd "colorscheme everforest"
            end,
        }

        -- Startup screen
        use {
            "goolord/alpha-nvim",
            config = function()
                require("config.alpha").setup()
            end,
        }

        -- Git
        use {
            "TimUntersberger/neogit",
            requires = "nvim-lua/plenary.nvim",
            config = function()
                require("config.neogit").setup()
            end,
        }
        
        -- IndentLine
        use {
            "lukas-reineke/indent-blankline.nvim",
            event = "BufReadPre",
            config = function()
                require("config.indentblankline").setup()
            end,
        }

        -- Better icons
        use {
            "nvim-tree/nvim-web-devicons",
        }
        
        -- Better surround
        use { 
            "tpope/vim-surround", 
            event = "InsertEnter" 
        }

        -- Better Comment
        use {
            "numToStr/Comment.nvim",
            keys = { "gc", "gcc", "gbc" },
            config = function()
                require("Comment").setup {}
            end,
        }

        -- Easy hopping
        use {
            "phaazon/hop.nvim",
            cmd = { "HopWord", "HopChar1" },
            config = function()
                require("hop").setup {}
            end,
            disable = true,
        }

        -- Easy motion
        use {
            "ggandor/lightspeed.nvim",
            keys = { "s", "S", "f", "F", "t", "T" },
            config = function()
                require("lightspeed").setup {}
            end,
        }

        -- Markdown
        use {
            "iamcco/markdown-preview.nvim",
            run = function()
                vim.fn["mkdp#util#install"]()
            end,
            ft = "markdown",
            cmd = { "MarkdownPreview" },
        }

        -- Status line
        use {
            "nvim-lualine/lualine.nvim",
            event = "VimEnter",
            config = function()
                require("config.lualine").setup()
            end,
            requires = { "nvim-web-devicons" },
        }
        
        -- Completion
        use {
            "ms-jpq/coq_nvim",
            branch = "coq",
            event = "VimEnter",
            opt = true,
            run = ":COQdeps",
            config = function()
                require("config.coq").setup()
            end,
            requires = {
                { "ms-jpq/coq.artifacts", branch = "artifacts" },
                { "ms-jpq/coq.thirdparty", branch = "3p", module = "coq_3p" },
            },
            disable = false,
        }

        -- Treesitter
        use {
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
            config = function()
                require("config.treesitter").setup()
            end,
        }

        use {
            "SmiteshP/nvim-gps",
            requires = "nvim-treesitter/nvim-treesitter",
            module = "nvim-gps",
            config = function()
                require("nvim-gps").setup()
            end,
        }
        
        -- FZF
        use {
            "junegunn/fzf",
            run = "./install --all",
            event = "VimEnter" 
        } 
        
        use {
            "junegunn/fzf.vim",
            event = "BufEnter" 
        }

        -- FZF Lua
        use {
            "ibhagwan/fzf-lua",
            event = "BufEnter",
            requires = { "nvim-tree/nvim-web-devicons" },
        }
        
        -- File Explorer
        use {
            "nvim-tree/nvim-tree.lua",
            requires = {
                "nvim-tree/nvim-web-devicons",
            },
            config = function()
                require("config.nvimtree").setup()
            end,
        }
        
        -- Auto pairs
        use {
            "windwp/nvim-autopairs",
            wants = "nvim-treesitter",
            module = { "nvim-autopairs.completion.cmp", "nvim-autopairs" },
            config = function()
                require("config.autopairs").setup()
            end,
        }
        
        -- Auto tag
        use {
            "windwp/nvim-ts-autotag",
            wants = "nvim-treesitter",
            event = "InsertEnter",
            config = function()
                require("nvim-ts-autotag").setup { enable = true }
            end,
        }

        -- End wise
        use {
            "RRethy/nvim-treesitter-endwise",
            wants = "nvim-treesitter",
            event = "InsertEnter",
            disable = false,
        }

        use { 
            "williamboman/mason.nvim",
            config = function()
                require("mason").setup()
            end,
        }

        use {
            "williamboman/mason-lspconfig.nvim" ,
            config = function()
                require("mason-lspconfig").setup({
                    ensure_installed = { "sumneko_lua", "rust_analyzer", "gopls" },
                    automatic_installation = true,
                })
            end,
        }

        -- LSP
        use {
            "neovim/nvim-lspconfig",
            config = function()
                require("config.lsp").setup()
            end,
        }
        
        -- Telescope
        use {
            'nvim-telescope/telescope.nvim', -- fuzzy finder
            requires = { {'nvim-lua/plenary.nvim'} }
        }

        if packer_bootstrap then
            print "Restart Neovim required after installation!"
            require("packer").sync()
        end
    end

    packer_init()

    local packer = require "packer"
    packer.init(conf)
    packer.startup(plugins)
end

return M
