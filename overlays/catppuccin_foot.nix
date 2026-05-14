final: prev: let
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix {
    inherit (prev) lib fetchFromGitHub;
  };
in {
  catppuccin-foot = prev.stdenv.mkDerivation {
    name = "catppuccin-foot";
    src = fetchFromGithubTuple {
      github-tags = ["catppuccin/foot" "8d263e0e6b58a6b9ea507f71e4dbf6870aaf8507"];
      hash = "sha256-bpGVDESE6Pr7kaFgfAWJ/5KC9mRPlv2ciYwRr6jcIKs=";
    };
    installPhase = ''
      cp --recursive themes/catppuccin-mocha.ini $out
    '';
  };
}
