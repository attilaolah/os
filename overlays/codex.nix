final: prev: let
  inherit (builtins) elemAt;
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["openai/codex" "0.154.0"]; # extractVersion=^rust-v(?<version>.*)$
  hash-src = "sha256-lHiDj5SodaM3mh8goMm6esfejeAT+Y3JJWrRnyj6sJo=";
  hash-cargo-deps = "sha256-GG6kOXmCdq+bZLU2ul0DIVL8lDuweayvZvXn6+bcUZw=";

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
