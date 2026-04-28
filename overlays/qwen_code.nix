final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix {
    inherit (prev) lib fetchFromGitHub;
  };

  github-tags = ["QwenLM/qwen-code" "0.15.3"]; # extractVersion=^v(?<version>.*)$
  hash = "sha256-zOKhu+nhSoEYBSodCb3mijaW0TCV0wTOqMOR5RLNdTM=";
  npmDepsHash = "sha256-m4xWuTbRSTkhzsCqSup9efj6YFKnsTp/POzIPKaN4r4=";

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
