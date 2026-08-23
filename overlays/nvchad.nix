final: prev: let
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = [
    "NvChad/NvChad"
    "v2.5"
  ];
  hash-src = "sha256-EuP+/HWJgqwG5LR2rNvtq7mhFkUDs0oyeG6xbbPogC4=";

  nvchad = prev.vimUtils.buildVimPlugin {
    pname = "nvchad";
    version = "2.5-unstable-2026-07-03-add44b952";
    # NvChad requires its user-supplied `chadrc` during module loading, so the
    # generic isolated Neovim require check cannot exercise this plugin.
    doCheck = false;
    src = fetchFromGitHubTuple {
      inherit github-tags hash-src;
      # Fetch the moving branch while retaining the Renovate-visible tag tuple.
      rev = "refs/heads/v2.5";
    };
    dependencies = with prev.vimPlugins; [
      gitsigns-nvim
      luasnip
      mason-nvim
      nvim-cmp
      nvim-lspconfig
      telescope-nvim
      nvim-treesitter
      nvchad-ui
    ];
  };
in {
  vimPlugins =
    prev.vimPlugins
    // {
      nvchad = nvchad;
    };
}
