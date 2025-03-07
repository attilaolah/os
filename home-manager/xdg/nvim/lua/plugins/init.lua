return {
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "cue",
        "diff",
        "dockerfile",
        "dot",
        "fish",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
        "go",
        "gomod",
        "gosum",
        "gotmpl",
        "gpg",
        "helm",
        "html",
        "http",
        "ini",
        "javascript",
        "json",
        "jsonnet",
        "kotlin",
        "lua",
        "markdown",
        "markdown_inline",
        "nix",
        "printf",
        "promql",
        "proto",
        "pug",
        "python",
        "ruby",
        "rust",
        "sql",
        "ssh_config",
        "starlark",
        "terraform",
        "textproto",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
        "zig",
      },
      auto_install = true,

      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    },
  },
}
