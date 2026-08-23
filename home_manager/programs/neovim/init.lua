vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- Bootstrap Lazy and all plugins.
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- Load plugins.
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- Load theme.  Base46's cache lives in Neovim's data directory, so it may be
-- absent after that state is cleared even though the plugin is installed.
local function load_base46_cache()
  local defaults = vim.g.base46_cache .. "defaults"
  local statusline = vim.g.base46_cache .. "statusline"

  if vim.fn.filereadable(defaults) == 0 then
    local ok, base46 = pcall(require, "base46")
    if ok and type(base46.compile) == "function" then
      pcall(base46.compile)
    else
      -- Let Lazy finish loading before making one safe deferred attempt.
      vim.schedule(function()
        local deferred_ok, deferred_base46 = pcall(require, "base46")
        if deferred_ok and type(deferred_base46.compile) == "function" then
          pcall(deferred_base46.compile)
        end
      end)
    end
  end

  if vim.fn.filereadable(defaults) == 1 then
    dofile(defaults)
  end
  if vim.fn.filereadable(statusline) == 1 then
    dofile(statusline)
  end
end

load_base46_cache()

require "options"
require "nvchad.autocmds"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)
