return {
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    -- config = function()
    --   vim.cmd([[colorscheme tokyonight]])
    -- end,
  },
  {
    'sainnhe/everforest',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme everforest]])
    end
  },
  {
    'folke/which-key.nvim',
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },
  { 'echasnovski/mini.indentscope',
    version = false,
    config = function()
      require('mini.indentscope').setup({
        draw = {
          animation = function() return 0 end
        },
        -- symbol = "┃",
      })
    end
  },
  {'tpope/vim-commentary'},
  {'windwp/nvim-ts-autotag'},
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      vim.api.nvim_set_var('loaded_netrw', 1)
      vim.api.nvim_set_var('loaded_netrwPlugin', 1)
      require("nvim-tree").setup({
        filters = {
          git_ignored = false,
        },
      })
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-web-devicons', opt = true },
    event = {'BufNewFile', 'BufRead'},
    options = {
      theme = 'everforest',
    },
    config = function()
      require('lualine').setup({
        options = {
          disabled_filetypes = {'NvimTree'}
        }
      })
    end
  },
  {
    'nanozuki/tabby.nvim',
    config = function()
      require('plugin/tabby')
    end
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      -- 'rcarriga/nvim-notify',
    }
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require("gitsigns").setup()
    end
  },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.2',
-- or                              , branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    'nvim-treesitter/nvim-treesitter',
    event = {'BufNewFile', 'BufRead'},
    build = ':TSUpdate',
    config = function()
      require('plugin/treesitter')
    end
  },
  {
    'uga-rosa/utf8.nvim',
  },

  {'williamboman/mason.nvim'},
  {'hrsh7th/cmp-nvim-lsp'},
  {'hrsh7th/cmp-buffer'},
  {'hrsh7th/cmp-path'},
  {'hrsh7th/cmp-cmdline'},
  {'hrsh7th/nvim-cmp'},
  {'hrsh7th/cmp-vsnip'},
  {'hrsh7th/vim-vsnip'},

  {'onsails/lspkind.nvim'},
  {'williamboman/mason.nvim'},
  {'williamboman/mason-lspconfig.nvim'},
  {'neovim/nvim-lspconfig'},
  {'jose-elias-alvarez/null-ls.nvim', dependencies = 'nvim-lua/plenary.nvim'},
}
