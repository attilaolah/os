final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix {
    inherit (prev) lib fetchFromGitHub;
  };

  github-tags = ["ggml-org/llama.cpp" "9010"]; # extractVersion=^b(?<version>.*)$
  hash = "sha256-TeE296MTX8jTNMnagr9UvwrHLSBC5TbB/sgVZOF13ok=";
  npmDepsHash = "sha256-k62LIbyY2DXvs7XXbX0lNPiYxuYzeJUyQtS4eA+68f8=";

  version = elemAt github-tags 1;
in {
  llama-cpp = prev.llama-cpp.overrideAttrs (_: {
    inherit version npmDepsHash;
    src = fetchFromGithubTuple {
      inherit github-tags hash;
      rev = "b${version}";
    };
  });
}
