vim.filetype.add {
  pattern = {
    ["templates/.*%.ya?ml"] = "helm",
    [".*/templates/.*%.ya?ml"] = "helm",
    ["templates/.*%.tpl"] = "gotmpl",
    [".*/templates/.*%.tpl"] = "gotmpl",
  },
}
