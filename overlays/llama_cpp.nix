final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["ggml-org/llama.cpp" "9159"]; # extractVersion=^b(?<version>.*)$
  hash = "sha256-YAlZRlKZwZyZV1kIr2C9MphGIcTI38HIODeUu+vpJw8=";
  npmDepsHash = "sha256-WaEePrEZ7O/7deP2KJhe0AwiSKYA8HOqETmMHUkmBe0=";

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
