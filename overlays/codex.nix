final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["openai/codex" "0.137.0"]; # extractVersion=^rust-v(?<version>.*)$
  hash-src = "sha256-puszZqi1lZeq8iXWAD9U9+WMnNvzMYKf6wVT9mtjSUU=";
  hash-cargo-deps = "sha256-SX5LMO+IWismbH61Jd0g1mgykfav8DrqG+wjyNCWyCo=";

  version = elemAt github-tags 1;
in {
  codex = prev.codex.overrideAttrs (_: let
    src = fetchFromGithubTuple {
      inherit github-tags;
      hash = hash-src;
      rev = "rust-v${version}";
    };
  in {
    inherit version src;
    cargoHash = hash-cargo-deps;
    cargoDeps = prev.rustPlatform.fetchCargoVendor {
      inherit src;
      cargoRoot = "codex-rs";
      hash = hash-cargo-deps;
    };
  });
}
