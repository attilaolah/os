final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["google-gemini/gemini-cli" "0.45.1"]; # extractVersion=^v(?<version>.*)$
  hash = "sha256-qab0cfc47C33enSmoV1t3GIkTSGFdC3tmY/ZCEAeF5Y=";
  npmDepsHash = "sha256-Xge7umt6zjs9Gb527n65u9TW/dGpmPRHylATGlx+5Rc=";

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
