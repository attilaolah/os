local nix_plugins = require("nix-plugins")

return {
  defaults = { lazy = true },
  install = {
    colorscheme = { "nvchad" },
    missing = false,
  },

  dev = {
    path = function(plugin)
      return nix_plugins[plugin.name] or "/nonexistent/nix-plugins/" .. plugin.name
    end,
    patterns = { "github.com", "codeberg.org" },
    fallback = true,
  },

  ui = {
    icons = {
      ft = "",
      lazy = "󰂠 ",
      loaded = "",
      not_loaded = "",
    },
  },

  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
}
