return {
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require "configs.conform"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
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
    },
  },
}
