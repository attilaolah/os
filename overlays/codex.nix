final: prev: let
  inherit (builtins) elemAt;
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["openai/codex" "0.156.1"]; # extractVersion=^rust-v(?<version>.*)$
  hash-src = "sha256-H53f57hmnyCtn5yPxtBe/A92qyQyzQBeU/vK2qSBrvI=";
  hash-cargo-deps = "sha256-W87rX/W2J1pwqNrihX+Rj6DfagoZYuB6C+l/S4BhyJM=";

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
