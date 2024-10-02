local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    nix = { "alejandra" },
    rust = { "rustfmt" },
    python = { "usort", "black" },
  },

  format_on_save = function(bufnr)
    -- Black is painfully slow, give it some slack.
    local slow = vim.bo[bufnr].filetype == "python"
    return {
      timeout_ms = slow and 2000 or 500,
      lsp_fallback = true,
    }
  end,
}

return options
