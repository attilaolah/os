-- This file needs to have same structure as nvconfig.lua.
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  -- This is Nix-managed and read-only in the live configuration; change the
  -- declaration here and rebuild rather than manually switching themes.
  theme = "catppuccin",
}

M.ui = {
  statusline = {
    separator_style = "block",
  },
}

return M
