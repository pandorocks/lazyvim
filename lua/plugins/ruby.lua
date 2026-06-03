return {
  -- Configure ruby_lsp
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {
          mason = false, -- Don't install via Mason since you're using the gem
          cmd = {
            "~/.local/share/mise/installs/ruby/4.0.5/bin/ruby",
            "-rbundler/setup",
            "~/.local/share/mise/installs/ruby/4.0.5/lib/ruby/gems/4.0.0/gems/ruby-lsp-0.26.9/exe/ruby-lsp",
          },
          settings = {
            rubyLsp = {
              formatter = "standard",
            },
          },
        },
        rubocop = {
          mason = false,
          cmd = {
            "~/.local/share/mise/installs/ruby/4.0.5/bin/ruby",
            "-rbundler/setup",
            "~/.local/share/mise/installs/ruby/4.0.5/lib/ruby/gems/4.0.0/gems/rubocop-1.84.2/exe/rubocop",
            "--lsp",
          },
        },
      },
    },
  },
  -- Endwise
  -- {
  --   "RRethy/nvim-treesitter-endwise",
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   config = function()
  --     require("nvim-treesitter.configs").setup({
  --       endwise = {
  --         enable = true,
  --       },
  --     })
  --   end,
  -- },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ruby = { "standardrb" },
        eruby = { "htmlbeautifier" }, -- Add ERB formatting
        css = { "prettier" },
        scss = { "prettier" },
      },
      -- format_on_save = {
      --   timeout_ms = 500,
      --   lsp_fallback = true,
      -- },
    },
  },

  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "standardrb",
        "htmlbeautifier",
      },
    },
  },

  {
    "tpope/vim-endwise",
    event = "InsertEnter",
    ft = { "ruby", "lua", "vim", "sh", "zsh", "elixir", "crystal", "matlab", "vb" },
  },
}
