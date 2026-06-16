require "nvchad.mappings"

local map = vim.keymap.set
local opts = { silent = true, noremap = true }

map("n", ";", ":", { desc = "CMD enter command mode" })
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Ctrl + Alt/Meta + Arrow keys
map("n", "<C-M-Left>", "<cmd>TmuxNavigateLeft<CR>", opts)
map("n", "<C-M-Down>", "<cmd>TmuxNavigateDown<CR>", opts)
map("n", "<C-M-Up>", "<cmd>TmuxNavigateUp<CR>", opts)
map("n", "<C-M-Right>", "<cmd>TmuxNavigateRight<CR>", opts)
