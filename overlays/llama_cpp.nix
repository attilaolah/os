final: prev: let
  inherit (builtins) elemAt;
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["ggml-org/llama.cpp" "10076"]; # extractVersion=^b(?<version>.*)$
  hash-src = "sha256-U5S1cFMQTOY17acCKGLGymkSttAq71td8O+0v452Dss=";
  hash-npm-deps = "sha256-B7uEynAG70a3xauBKc20RuFa9cnWaWzVBCh+LPLBnIM=";

  version = elemAt github-tags 1;
in {
  llama-cpp = prev.llama-cpp.overrideAttrs (_: {
    inherit version;
    npmDepsHash = hash-npm-deps;
    src = fetchFromGitHubTuple {
      inherit github-tags hash-src;
      rev = "b${version}";
    };
  });
}
