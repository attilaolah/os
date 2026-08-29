final: prev: let
  inherit (builtins) elemAt;
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["openai/codex" "0.151.0"]; # extractVersion=^rust-v(?<version>.*)$
  hash-src = "sha256-snrzA4W+vLqpPk3MS4xw9SszK1byCKo6ERz3JDgRZdA=";
  hash-cargo-deps = "sha256-r6ox0dUH1OBkD8sQApfANrGbWxKXLv2UNLJZzciJc3I=";

  version = elemAt github-tags 1;
in {
  codex = prev.codex.overrideAttrs (_: let
    src = fetchFromGitHubTuple {
      inherit github-tags hash-src;
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
