final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix {
    inherit (prev) lib fetchFromGitHub;
  };

  github-tags = ["QwenLM/qwen-code" "0.15.8"]; # extractVersion=^v(?<version>.*)$
  hash = "sha256-gSUSgBVTB6UKq/0qaDJpZcKRxD7H3eCEK5vOPMo0cvE=";
  npmDepsHash = "sha256-nI8gQSLr1HSHGOulPcoZroOJAn901RwVWJMIZN422KQ=";

  version = elemAt github-tags 1;
in {
  qwen-code = prev.qwen-code.overrideAttrs (old: let
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
