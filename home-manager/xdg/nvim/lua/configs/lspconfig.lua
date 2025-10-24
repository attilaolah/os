-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local nvlsp = require "nvchad.configs.lspconfig"

local servers = {
  "ansiblels",
  "cssls",
  "html",
  "kotlin_language_server",
  "nil_ls",
  "pyright",
  "rust_analyzer",
  "ts_ls",
}

-- LSPs with default config
vim.lsp.enable(servers)

vim.lsp.config("*", {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
})

-- Go
vim.lsp.config("gopls", {
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      gofumpt = true,
      staticcheck = true,
      usePlaceholders = true,
    },
  },
})

-- Helm
vim.lsp.config("helm_ls", {
  settings = {
    ["helm-ls"] = {
      yamlls = {
        path = "yaml-language-server",
      },
    },
  },
})

-- YAML
vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
      },
    },
  },
})
