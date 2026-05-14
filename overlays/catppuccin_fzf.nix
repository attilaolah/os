final: prev: let
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix {
    inherit (prev) lib fetchFromGitHub;
  };
in {
  catppuccin-fzf = prev.stdenv.mkDerivation {
    name = "catppuccin-fzf";
    src = fetchFromGithubTuple {
      github-tags = ["catppuccin/fzf" "7c2e05606f2e75840b1ba367b1f997cd919809b3"];
      hash = "sha256-fs3bOs1vfrtuono0yg1xjTSpzoS5m8ZRMD+CjAp+sDU=";
    };
    installPhase = ''
      cp --recursive themes/catppuccin-fzf-mocha.fish $out
    '';
  };
}
