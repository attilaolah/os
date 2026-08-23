final: prev: let
  inherit (builtins) elemAt;
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = [
    "NvChad/NvChad"
    "v2.5"
  ];
  hash-src = "sha256-EuP+/HWJgqwG5LR2rNvtq7mhFkUDs0oyeG6xbbPogC4=";

  version = elemAt github-tags 1;
  treesitter =
    (prev.vimPlugins.nvim-treesitter.withPlugins (
      parsers:
        with parsers; [
          bash
          c
          cpp
          css
          cue
          diff
          dockerfile
          dot
          fish
          git_config
          git_rebase
          gitcommit
          gitignore
          go
          gomod
          gosum
          gotmpl
          gpg
          helm
          html
          http
          ini
          javascript
          json
          jsonnet
          kotlin
          lua
          markdown
          markdown_inline
          nix
          printf
          promql
          proto
          pug
          python
          ruby
          rust
          sql
          ssh_config
          starlark
          terraform
          textproto
          typescript
          vim
          vimdoc
          xml
          yaml
          zig
        ]
    )).overrideAttrs
    (old: {
      passthru =
        (old.passthru or {})
        // {
          inherit (prev.vimPlugins.nvim-treesitter) grammarPlugins;
        };
    });
  nvchad = prev.vimUtils.buildVimPlugin {
    pname = "nvchad";
    inherit version;
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
      treesitter
      nvchad-ui
    ];
  };
in {
  vimPlugins =
    prev.vimPlugins
    // {
      nvim-treesitter = treesitter;
      nvchad = nvchad;
    };
}
