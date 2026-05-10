final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix {
    inherit (prev) lib fetchFromGitHub;
  };

  github-tags = ["QwenLM/qwen-code" "0.15.10"]; # extractVersion=^v(?<version>.*)$
  hash = "sha256-t0NNXSyoHEnPc3UTNibWgYf44sWY046M8ebkQDkSn4I=";
  npmDepsHash = "sha256-AdRwv7/POV1XeZ4yzEDnXmDDLo+NA2VR9tQyYP9MXzY=";

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
