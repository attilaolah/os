local options = {
  formatters_by_ft = {
    css = { "prettier" },
    html = { "prettier" },
    kotlin = { "ktfmt" },
    lua = { "stylua" },
    nix = { "alejandra" },
    python = { "usort", "black" },
    rust = { "rustfmt" },
  },

  format_on_save = function(bufnr)
    local slow = vim.tbl_contains({
      "python", -- black is slow
      "kotlin", -- ktfmt is slow
    }, vim.bo[bufnr].filetype)
    return {
      timeout_ms = slow and 2000 or 500,
      lsp_fallback = true,
    }
  end,
}

return options
