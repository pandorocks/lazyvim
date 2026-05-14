-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("n", "<CR>", ":w<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>cp", function()
  local filepath = vim.fn.expand("%")
  if filepath == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", filepath)
  vim.notify("Copied to clipboard: " .. filepath)
end, { desc = "Copy file path to clipboard" })

vim.keymap.set("n", "<leader>bo", function()
  local snacks_bufname = "snacks://" -- adjust this if your snacks buffer uses a different pattern

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if name ~= "" and not name:match("^" .. snacks_bufname) then
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end
  end

  -- Open a fresh empty buffer
  vim.cmd("enew")
end, { desc = "Close all buffers except Snacks" })
