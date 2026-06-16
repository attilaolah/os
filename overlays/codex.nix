final: prev: let
  inherit (builtins) elemAt;
  fetchFromGithubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["openai/codex" "0.140.0"]; # extractVersion=^rust-v(?<version>.*)$
  hash-src = "sha256-VuvNXgyftiQke8qLA7HEySkP4S2TvMR++rrVJAfVc4Y=";
  hash-cargo-deps = "sha256-8nvIfbq2EKqbF4fyzB5wakQilV4NU5S2wSXJk1KGnB0=";

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
