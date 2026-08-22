final: prev: let
  inherit (builtins) elemAt;
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["openai/codex" "0.149.0"]; # extractVersion=^rust-v(?<version>.*)$
  hash-src = "sha256-SMVTW/CcGz4xxyeFe3KUf3Ns6jp+2SRMTvtA2o2+y7Q=";
  hash-cargo-deps = "sha256-K58PL588Hhk75FyXgU6b8IEAco8FIz8oGd1S0WgOjyQ=";

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
