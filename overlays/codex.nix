final: prev: let
  inherit (builtins) elemAt;
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["openai/codex" "0.149.1"]; # extractVersion=^rust-v(?<version>.*)$
  hash-src = "sha256-nRJ48yuIkgHfIZQQY8vXW3oQEOCCoHACz5AsaIkI2ms=";
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
