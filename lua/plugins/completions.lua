return {
  "milanglacier/minuet-ai.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("minuet").setup({
      provider = "openai_fim_compatible",
      n_completions = 1, -- recommend for local models to save compute
      context_window = 512,
      provider_options = {
        openai_fim_compatible = {
          -- Ollama doesn't need a real key; this just points at any
          -- env var that is set so the check passes.
          api_key = "TERM",
          name = "Ollama",
          end_point = "http://localhost:11434/v1/completions",
          model = "qwen2.5-coder:1.5b",
          optional = {
            max_tokens = 56,
            top_p = 0.9,
          },
        },
      },
      virtualtext = {
        auto_trigger_ft = { "*" }, -- enable ghost text everywhere
        keymap = {
          accept = "<A-A>", -- accept whole completion
          accept_line = "<A-a>", -- accept one line
          prev = "<A-[>",
          next = "<A-]>",
          dismiss = "<A-e>",
        },
      },
    })
  end,
}
