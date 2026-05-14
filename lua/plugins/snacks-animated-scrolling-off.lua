return {
  "folke/snacks.nvim",
  opts = {
    scroll = {
      enabled = false, -- Disable scrolling animations
    },

    notifier = {
      enabled = true,
    },

    picker = {
      hidden = true,
      ignored = true,
      exclude = { "node_modules", ".git" },

      keymaps = {
        ["<C-x>"] = "split", -- horizontal split
        ["<C-v>"] = "vsplit", -- vertical split
        ["<C-t>"] = "tab", -- new tab
      },

      sources = {
        explorer = {
          hidden = true,

          layout = {
            layout = {
              position = "right",
              width = 30,
            },
          },
        },

        files = {
          hidden = true,
        },
      },
    },
  },
}
