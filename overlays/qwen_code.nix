final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix {
    inherit (prev) lib fetchFromGitHub;
  };

  github-tags = ["QwenLM/qwen-code" "0.14.3"]; # extractVersion=^v(?<version>.*)$
  hash = "sha256-RtZlwZev8zv3yMn+cCQpGvyPq/gyA39N4Iq0qFBTERY=";
  npmDepsHash = "sha256-mrc46cZJ2hI1VL/PMYsCCkgEGYMHrkhLZs0EfsXRRIw=";

  version = elemAt github-tags 1;
in {
  qwen-code = prev.qwen-code.overrideAttrs (_old: {
    inherit version npmDepsHash;
    src = fetchFromGithubTuple {
      inherit github-tags hash;
      rev = "v${version}";
    };
  });
}
