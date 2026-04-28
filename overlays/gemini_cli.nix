final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix {
    inherit (prev) lib fetchFromGitHub;
  };

  github-tags = ["google-gemini/gemini-cli" "0.38.1"]; # extractVersion=^v(?<version>.*)$
  hash = "sha256-Iq/KxQ8rbLtXDbGzcZxspfFwar189H3mBWwOD4hO7HU=";
  npmDepsHash = "sha256-T3fxNFvkLR7f49GQjzzTnl3VM+VUUgJfFF5d2GGe7L4=";

  version = elemAt github-tags 1;
in {
  gemini-cli = prev.gemini-cli.overrideAttrs (_old: {
    inherit version npmDepsHash;
    src = fetchFromGithubTuple {
      inherit github-tags hash;
      rev = "v${version}";
    };
  });
}
