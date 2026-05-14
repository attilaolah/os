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
}
