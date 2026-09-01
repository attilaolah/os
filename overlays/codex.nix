final: prev: let
  inherit (builtins) elemAt;
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["openai/codex" "0.152.0"]; # extractVersion=^rust-v(?<version>.*)$
  hash-src = "sha256-UmdecJhS8khsz8BZzIBgmvdj589dQ/gCrbJtRj9uoBg=";
  hash-cargo-deps = "sha256-m50x+ClPnbxhq0Lg9csDkfOLbHh3EAqVNSM1gwEF8rk=";

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
