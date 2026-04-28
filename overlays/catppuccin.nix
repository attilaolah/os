final: prev: let
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix {
    inherit (prev) lib fetchFromGitHub;
  };
in {
  catppuccin-atuin = prev.stdenv.mkDerivation {
    name = "catppuccin-atuin";
    src = fetchFromGithubTuple {
      github-tags = ["catppuccin/atuin" "abfab12de743aa73cf20ac3fa61e450c4d96380c"];
      hash = "sha256-t/Pq+hlCcdSigtk5uzw3n7p5ey0oH/D5S8GO/0wlpKA=";
    };
    installPhase = ''
      cp --recursive themes/mocha $out
    '';
  };

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
