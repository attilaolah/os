final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix {
    inherit (prev) lib fetchFromGitHub;
  };

  github-tags = ["google-gemini/gemini-cli" "0.40.1"]; # extractVersion=^v(?<version>.*)$
  hash = "sha256-d9CtwQQmblQs9BqdWPY9z9Q1fC41830Xqa1L2SFgEpI=";
  npmDepsHash = "sha256-mLldQUB8mFoeyXF90y1pPzM87LETCmJAAP/JlnTzgFc=";

  version = elemAt github-tags 1;
in {
  gemini-cli = prev.gemini-cli.overrideAttrs (old: let
    src = fetchFromGithubTuple {
      inherit github-tags hash;
      rev = "v${version}";
    };
  in {
    inherit version npmDepsHash src;
    npmDeps = old.npmDeps.overrideAttrs (_: {
      inherit src;
      outputHash = npmDepsHash;
    });
  });
}
